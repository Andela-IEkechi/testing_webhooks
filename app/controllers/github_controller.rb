class GithubController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:commit]
  skip_before_filter :load_membership #we act as the project on commit hooks, not as a user
  protect_from_forgery :except => :commit

  def commit
    if api_key = ApiKey.find_by_token(params["token"])
      @project = api_key.project
      payload = JSON.parse(params["payload"]) rescue {}

#do not remove, used for tracking problem on servers, too late to put it on afterward we have had a problem
Rails.logger.info "GitHub payload: #{payload}"
# p payload #do not remove, used for debugging

      payload["commits"].each do |commit|
        commit = commit.with_indifferent_access

        #first we check if we have processed this commit before
        if Comment.find_all_by_git_commit_uuid(commit["id" ]).count == 0 #we could have commented on multiple tickets for the same commit
          #find the ticket it relates to
          commit_msg = commit["message"]

          #parse the message to get the ticket number(s)
          #which looks like [#123<...>]
          commit_msg.scan(/\[#(\d+)([^\]]*)\]/).each do |ticket_ref,others|
            #find the ticket the matches
            ticket = @project.tickets.find_by_scoped_id(ticket_ref.to_i)
            if ticket
              #the committer might be a user we know about, so we try and find them
              commit_user = User.find_by_email(commit['author']['email']) rescue nil
              commit_user ||= User.find_by_github_login(commit['author']['username']) rescue nil
Rails.logger.info "Attributing commit to user: #{commit_user || 'unknown'}"

              #set up the attrs we want to persist
              attributes = {
                :body => commit_message(commit),
                :api_key_name => api_key.name,
                :commenter => commit['author']['email'],
                :git_commit_uuid => commit['id'],
                #set the creation date to be the commit date in the github payload, so that the comments
                #will be in chronological order
                :created_at => commit["timestamp"],
                :user_id => (commit_user.id rescue nil)
              }.with_indifferent_access

              #we need to append the attributes from this commit, to whatever was on the last comment. So we use reverse_merge
              if ticket.last_comment
                last_comment_attrs = ticket.last_comment.attributes.reject{ |k,v| %w(id created_at updated_at user_id).include?(k) }.with_indifferent_access
                attributes.reverse_merge!(last_comment_attrs)
              end

              #add the settings we passed into the commit message, to the ticket
              attributes.merge!(comment_to_hash(others, ticket)) unless others.blank?

              ticket.comments.create(attributes)
            else
Rails.logger.info "Could not find ticket for reference: #{ticket_ref}"
            end
          end
        end #else we already created a coment for this commit message

      end if payload["commits"]
    end #no key  = no comment
    render :text => "success"
  end

  private

  def commit_message(commit)
    "#{commit['message']}\n\n[view on GitHub](#{commit['url']})"
  end

  # "cost:1 assigned:joe@foo.org" -> {:cost=>1, :assignee_id=>3456}
  def comment_to_hash(message, ticket)
    attributes = {}
    message.scan(/([^\s]+):([^\s]+)/).collect do |key, value|
      case key
      when 'cost'
        attributes['cost'] = value
      when 'assigned', 'assigned', 'assignee', 'user'
        attributes['assignee_id'] = (ticket.project.memberships.by_email(value).first.user_id rescue nil)
      when 'sprint'
        attributes['sprint_id'] = (ticket.project.sprints.find_by_scoped_id(value).id rescue nil)
      when 'feature'
        attributes['feature_id'] = (ticket.project.features.find_by_scoped_id(value).id rescue nil)
      when 'status'
        attributes['status_id'] = (ticket.project.ticket_statuses.find_by_name(value).id rescue nil)
      end
    end
    attributes.reject{|k,v| v.nil? }
  end

end

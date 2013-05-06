class GithubController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:commit]
  skip_before_filter :load_membership #we act as the project on commit hooks, not as a user
  protect_from_forgery :except => :commit

  def commit
    if api_key = ApiKey.find_by_token(params["token"])
      p params
      @project = api_key.project
      payload = JSON.parse(params["payload"])
      payload["commits"].each do |commit|

        #first we check if we have processed this commit before
        if Comment.find_all_by_git_commit_uuid(commit["id" ]).count == 0 #we could have commented on multiple tickets for the same commit
          #find the ticket it relates to
          commit_msg = commit["message"]

          #parse the message to get the ticket number(s)
          #which looks like [#123<...>]

          commit_msg.scan(/\[#(\d+)(.*?)\]/).flatten.each do |ticket_ref,others|
            #find the ticket the matches
            ticket = @project.tickets.find_by_scoped_id(ticket_ref.to_i)

            others.strip! # remove leading space from the rest of the message

            #set up the attrs we want to persist
            attributes = {
              :body => commit_message(commit),
              :api_key_name => api_key.name,
              :commenter => commit['author']['email'],
              :git_commit_uuid => commit['id']
            }
            attributes.merge!(ticket.last_comment.attributes.reject{ |k,v| %w(id created_at updated_at user_id).include?(k) }) if ticket.last_comment

            attributes.merge!(comment_to_hash(others))
            ticket.comments.create(attributes)
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

  private

  def commit_message(commit)
    "#{commit['message']}\n\n[view on GitHub](#{commit['url']})"
  end

  # "cost:1 assigned:joe@foo.org" -> {:cost=>1, :assignee_id=>3456}
  def comment_to_hash(message)

    temp = {}
    output = {}

    message.split(" ").each do |part|
      pair = part.split(":")
      temp[pair[0].to_sym] = pair[1] if (pair.count == 2)
    end

    output[:cost] = temp[:cost].to_i if (temp.has_key? :cost)

    if temp.has_key? :assigned
      assignee = @project.participants.find_by_email( temp[:assigned] )
      output[:assignee_id] = assignee.id if assignee
    end

    if temp.has_key? :sprint
      sprint = @project.sprints.find_by_goal( temp[:sprint] )
      output[:sprint_id] = sprint.id if sprint
    end

    if temp.has_key? :feature
      feature = @project.features.find_by_title( temp[:feature] )
      output[:feature_id] = feature.id if feature
    end

    if temp.has_key? :status
      status = @project.ticket_statuses.find_by_name( temp[:status] )
      output[:status_id] = status.id if status
    end

    output

  end

end

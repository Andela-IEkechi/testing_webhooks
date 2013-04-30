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
          #which looks like [#123]
          commit_msg.scan(/\[#(\d+\.*)\]/).flatten.each do |ticket_ref|  #looks like '123'
            #find the ticket the matches
            ticket = @project.tickets.find_by_scoped_id(ticket_ref.to_i)

            #set up the attrs we want to persist
            attributes = {
              :body => commit_message(commit),
              :api_key_name => api_key.name,
              :commenter => commit['author']['email'],
              :git_commit_uuid => commit['id']
            }
            attributes.merge!(ticket.last_comment.attributes.reject{ |k,v| %w(id created_at updated_at user_id).include?(k) }) if ticket.last_comment
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
end

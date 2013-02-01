class GithubController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:commit]
  protect_from_forgery :except => :commit

  def commit
    if api_key = ApiKey.find_by_token(params["token"])
      @project = api_key.project
      payload = JSON.parse(params["payload"])
      payload["commits"].each do |commit|
        #find the ticket it relates to
        commit_msg = commit["message"]

        # parse the message to get the ticket number(s)
        # which looks like [#123<...>]
        commit_msg.scan(/\[#(\d+)(.*?)\]/).each do |ticket_ref, others|

          others.strip! # remove leading space from the rest of the message

          # there's a number, let's find the ticket it matches to
          ticket = @project.tickets.find_by_scoped_id(ticket_ref.to_i)

          ticket_params = comment_to_hash(others)

          # post the commit message as a ticket comment
          decorated_message = "#{commit['author']['email']} #{commit['message']}\n\n[#{commit['id']}](#{commit['url']})"

          ticket_params.merge!({ :body => decorated_message,
                                 :api_key_name => api_key })

          ticket.comments.create(ticket_params)

        end
      end if payload["commits"]
    end #no key  = no comment
    render :text => "commit received"
  end

  private

  def comment_to_hash(message)

    temp = {}
    output = {}

    message.split(" ").each do |part|
      pair = part.split(":")
      if pair.count == 2
        temp[pair[0].to_sym] = pair[1]
      end
    end

    # Cost
    if temp.has_key? :cost
      output[:cost] = temp[:cost]
    end

    # Assigned
    if temp.has_key? :assigned
      assignee = @project.participants.find_by_email( temp[:assigned] )
      if assignee
        output[:assignee_id] = assignee.id
      end
    end

    # TODO:
    # :sprint -> :sprint_id
    # :feature -> :feature_id
    # :status -> :status_id

    output

  end

end

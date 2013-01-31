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
        #parse the message to get the ticket number(s)
        #which looks like [#123]
        commit_msg.scan(/\[#(\d+\.*)\]/).flatten.each do |ticket_ref|
          #looks like '123'
          #find the ticket the matches
          ticket = @project.tickets.find_by_scoped_id(ticket_ref.to_i)
          #post the commit message as a ticket comment
          decorated_message = "#{commit['author']['email']} #{commit['message']}\n\n[#{commit['id']}](#{commit['url']})"
          attributes = {:body => decorated_message, :api_key_name => api_key}
          attributes.merge!(ticket.last_comment.attributes.reject{ |k,v| %w(id created_at updated_at).include?(k) }) if ticket.last_comment
          ticket.comments.create(attributes)
        end
      end if payload["commits"]
    end #no key  = no comment
    render :text => "commit received"
  end
end

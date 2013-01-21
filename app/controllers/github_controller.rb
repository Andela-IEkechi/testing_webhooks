class GithubController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:commit]
  protect_from_forgery :except => :commit

  load_resource :project

  def commit
    p "processing commits..."
    p params
    payload = params["payload"]
    payload["commits"].each do |commit|
      #whodunnit
      if user = User.find_by_email(commit["author"]["email"])
        p "found user #{user}"

        #find the ticket it relates to
        commit_msg = commit["message"]
        #parse the message to get the ticket number(s)
        #which looks like [#123]
        commit_msg.scan(/\[#(\d+\.*)\]/).flatten.each do |ticket_ref|
          #looks like '123'
          #find the ticket the matches
          ticket = @project.tickets.find_by_scoped_id(ticket_ref.to_i)
          #post the commit message as a ticket comment
          decorated_message = "#{commit['message']}\n\n[#{commit['id']}](#{commit['url']})"
          ticket.comments.create(:body => decorated_message, :user_id => user.id)
        end
      else
        p "no user, no comment"
      end #no user  = no comment
    end if payload["commits"]
    render :text => "commit received"
  end
end

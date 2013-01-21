class GithubController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:commit]

  load_resource :project

  def commit
    p "git commit seen for project #{@project}"
    params["commits"].each do |commit|
      p "processing commit: #{commit}"
      #whodunnit
      if user = User.find_by_email(commit["author"]["email"])
        p "comitter is user #{user}"
        #find the ticket it relates to
        commit_msg = commit["message"]
        p "commit message looks like #{commit_msg}"
        #parse the message to get the ticket number(s)
        #which looks like [#123]
        commit_msg.scan(/\[#(\d+\.*)\]/).flatten.each do |ticket_ref|
          p "found ticket ref: #{ticket_ref}"
          #looks like '123'
          #find the ticket the matches
          ticket = @project.tickets.find_by_scoped_id(ticket_ref.to_i)
          p "found ticket #{ticket}"
          #post the commit message as a ticket comment
          decorated_message = "#{commit[:message]}\n\n[#{commit[:id]}](#{commit[:url]})"
          p "comment looks like #{decorated_message}"
          ticket.comments.create(:body => decorated_message, :user_id => user.id)
        end
      end #no user  = no comment
    end if params["commits"]
  end
=begin
    commits": [ { "added": [], "author": { "email": "fm.marais@gmail.com", "name": "fmarais", "username": "fmarais" },
                               "committer": { "email": "fm.marais@gmail.com", "name": "fmarais", "username": "fmarais" },
                               "distinct": false,
                               "id": "da847bbe15e09b33dcb84da1ed195b4fcf4da411",
                               "message": "when pressing cancell in edit comment screen, you will go back to the current ticket insead of going back to project page",
                               "modified": [ "app/views/comments/_form.html.erb" ],
                               "removed": [],
                               "timestamp": "2012-12-14T05:46:15-08:00",
                               "url": "https://github.com/Shuntyard/Conductor/commit/da847bbe15e09b33dcb84da1ed195b4fcf4da411" }
=end
  render :text => "commit received"
end

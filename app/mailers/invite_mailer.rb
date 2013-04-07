class InviteMailer < ActionMailer::Base
  add_template_helper(CommentsHelper)
  default from: "no-reply@conductor-app.co.za"

  layout 'email'

  def invite_request(recipients, user, project)
    @user = user
    @project = project
    mail(:to => "#{recipients.join(',')}", #http://www.ruby-forum.com/topic/185075
         :subject => "#{@user.full_name} has requested access to #{@project.title}")
  end
end

class InviteMailer < ActionMailer::Base
  default from: "no-reply@conductor-app.co.za"

  layout 'email'

  def invite_request(user, project)
    @user = user
    @project = project
    recipients = @project.memberships.admins.collect(&:email)
    mail(:to => "#{recipients.join(',')}", #http://www.ruby-forum.com/topic/185075
         :subject => "Access request: #{@user.email} has requested access to #{@project.title}")
  end

  def invite_confirm(user, project)
    @user = user
    @project = project
    mail(:to => "#{@user.email}",
         :subject => "Access request: your request to join #{@project.title} has been sent to the project administrator(s)")
  end

end

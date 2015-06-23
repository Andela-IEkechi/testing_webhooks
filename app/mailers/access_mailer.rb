class AccessMailer < ActionMailer::Base
  default from: "no-reply@conductor-app.co.za"

  layout 'email'

  def project_notification(user, project)
    @user = user
    @project = project
    #attachments.inline["logo.png"] = File.read("#{Rails.root}/public/images/logo.png")
    mail(:to => "#{@user.email}", #http://www.ruby-forum.com/topic/185075
         :subject => "Access: #{@project}")
  end

end

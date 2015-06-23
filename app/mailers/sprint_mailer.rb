class SprintMailer < ActionMailer::Base
  add_template_helper(CommentsHelper)
  default from: "no-reply@conductor-app.co.za"

  layout 'email'

  def status_notification(recipients, sprint)
    @sprint = sprint
    mail(:to => "#{recipients.join(',')}", :subject => "Sprint status: #{@sprint}")
  end
end


class SprintMailer < ActionMailer::Base
  default from: "no-reply@conductor-app.co.za"

  layout 'email'

  def status_notification(recipients, sprint)
    @sprint = sprint
    mail(:to => "#{recipients.join(',')}", :subject => "#{@sprint.project.title}: '#{@sprint}' sprint status")
  end
end


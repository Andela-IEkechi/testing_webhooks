namespace "sprint" do
  desc 'Sends mail to all participants of each open sprint.'
  task :send_status_notifications => :environment do
    Sprint.all.select{|s| s.notify_while_open}.select{|s| s.has_open_tickets?}.each do |sprint|
      participants = sprint.participants.select{|u| u.preferences.sprint_notification.to_i == 1 } #pref stored as "0"/"1"

      #dont sent emails to people who have left the project!
      recipients = participants.select{|r| r.memberships.to_project(sprint.project_id).any?}.collect(&:email)

      SprintMailer.status_notification(recipients, sprint).deliver if recipients.any?
    end
  end
end

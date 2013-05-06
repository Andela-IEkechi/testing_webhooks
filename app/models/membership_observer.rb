class MembershipObserver < ActiveRecord::Observer
  observe :membership

  cattr_accessor :disable_notifications # use this when doing migrations

  def after_create(record)
    return if MembershipObserver.disable_notifications
    AccessMailer.project_access_notification(record.user, record.project).deliver if record.user.confirmed? && !record.project.memberships.all.collect(&:user_id).include?(record.user_id)
  end
end




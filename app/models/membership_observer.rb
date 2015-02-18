class MembershipObserver < ActiveRecord::Observer
  observe :membership

  cattr_accessor :disable_notifications # use this when doing migrations

  # don't check after_create, otherwise the user will have a membership already
  # and no emails are sent

  def before_create(record)
    return if MembershipObserver.disable_notifications
    #dont send notifications to:
    # unconfirmed users
    # project owners
    # people who are already members
    AccessMailer.project_notification(record.user, record.project).deliver if record.user.confirmed? && record.user_id != record.project.user_id && !record.project.memberships.all.collect(&:user_id).include?(record.user_id)
  end
end




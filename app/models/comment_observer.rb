class CommentObserver < ActiveRecord::Observer
  observe :comment

  cattr_accessor :disable_notifications # use this when doing migrations

  def after_create(record)
    return if CommentObserver.disable_notifications

    #send an email to ticket stakeholders
    TicketMailer.ticket_comment_notification(record.ticket.assignees.collect(&:email).uniq, record).deliver

  end
end




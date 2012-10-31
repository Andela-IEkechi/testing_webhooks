class CommentObserver < ActiveRecord::Observer
  observe :comment

  cattr_accessor :disable_notifications # use this when doing migrations

  def after_create(record)
    return if CommentObserver.disable_notifications

    #send an email to ticket
    if (record.ticket.assignees.size > 0)
      recipients = record.ticket.assignees.collect(&:email).uniq
      TicketMailer.ticket_comment_notification(recipients, record).deliver
    end
  end
end




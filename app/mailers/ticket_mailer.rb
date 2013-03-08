class TicketMailer < ActionMailer::Base
  add_template_helper(CommentsHelper)
  default from: "no-reply@conductor-app.co.za"

  layout 'email'

  def ticket_comment_notification(recipients, comment)
    @comment = comment
    #attachments.inline["logo.png"] = File.read("#{Rails.root}/public/images/logo.png")
    mail(:to => "#{recipients.join(',')}", #http://www.ruby-forum.com/topic/185075
         :subject => "Project #{@comment.project.title}. Ticket #{@comment.ticket.scoped_id}: #{@comment.ticket} has been updated")
  end
end

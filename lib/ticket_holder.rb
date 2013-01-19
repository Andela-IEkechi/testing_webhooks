module TicketHolder
  extend ActiveSupport::Concern

  included do
    has_many :comments

    before_destroy :orphan_comments!

    def orphan_comments!
      self.comments.each do |comment|
        comment.feature = nil
        comment.sprint = nil
        comment.save!
      end
    end

    def cost
      assigned_tickets.sum(&:cost)
    end

    def assigned_tickets
      eval("Ticket.for_#{self.class.name.downcase}_id(#{self.id})")
    end

    def open_tickets
      assigned_tickets.collect(&:status).select{|s| s.open}
    end

    def closed_tickets
      assigned_tickets.collect(&:status).select{|s| !s.open}
    end

    def has_open_tickets?
      open_tickets.count > 0
    end

    def completion_percentage
      return 0 if assigned_tickets.count == 0
      (closed_tickets.count/(assigned_tickets.count*1.0)).round(2)
    end

    def completion_message
      return "nothing assigned" if assigned_tickets.count == 0
      "#{closed_tickets.count} of #{assigned_tickets.count} tickets closed"
    end

  end
end

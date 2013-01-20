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

  end
end

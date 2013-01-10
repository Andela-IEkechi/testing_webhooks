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
  end
end

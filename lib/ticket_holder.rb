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

    # returns ticket counts per status
    # t = "open"
    # f = "closed"
    # a = "open" + "closed"
    def ticket_status_count 
      @ticket_status_count  ||= begin
        counts = { "a" => 0, "t" => 0, "f" => 0 }
        counts.merge! assigned_tickets.joins(:status).sum(1, group: 'ticket_statuses.open')        
        counts.each{ |k,v| counts[k] = v.to_f; counts["a"] += counts[k] }
      end  
    end

    def progess_count
      (100*closed_ticket_count/ticket_count).round
    end

    def open_ticket_count
      ticket_status_count["t"]
    end

    def closed_ticket_count
      ticket_status_count["f"]
    end

    def ticket_count
      ticket_status_count["a"]
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

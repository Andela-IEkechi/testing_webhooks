module TicketHolder
  extend ActiveSupport::Concern

  included do
    has_many :tickets #tickets are tied to a project, so we dont destroy them if we
    before_destroy :orphan_tickets!

    def orphan_tickets!
      self.tickets.each do |ticket|
        ticket.feature = nil
        ticket.save!
      end
    end
  end

end

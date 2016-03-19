class InitTicketScopedId < ActiveRecord::Migration
  def up
    Project.find_each do |project|
      last_ticket_id = (project.tickets.order('id ASC').last.id rescue 0)
      project.tickets_sequence = last_ticket_id
      project.save!

      project.tickets.find_each do |ticket|
        ticket.scoped_id = ticket.id
        ticket.save!
      end
    end

  end

  def down
  end
end

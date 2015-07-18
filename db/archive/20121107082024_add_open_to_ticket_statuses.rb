class AddOpenToTicketStatuses < ActiveRecord::Migration
  def change
    add_column :ticket_statuses, :open, :boolean, :default => true
  end
end

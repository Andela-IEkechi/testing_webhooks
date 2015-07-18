class AddSortIndexToTicketStatuses < ActiveRecord::Migration
  def change
    add_column :ticket_statuses, :sort_index, :integer
  end
end

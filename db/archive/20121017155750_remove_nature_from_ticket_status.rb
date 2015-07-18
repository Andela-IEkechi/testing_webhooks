class RemoveNatureFromTicketStatus < ActiveRecord::Migration
  def up
    remove_column :ticket_statuses, :nature
  end

  def down
    add_column :ticket_statuses, :nature, :string, :default => 'undefined'
  end
end

class RemoveStatusIdColumnFromTicketTable < ActiveRecord::Migration
  def up
    remove_column :tickets, :status_id
  end

  def down
  end
end

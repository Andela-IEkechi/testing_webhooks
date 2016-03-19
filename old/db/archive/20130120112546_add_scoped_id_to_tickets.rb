class AddScopedIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :scoped_id, :integer, :default => 0
    add_index :tickets, :project_id
    add_index :tickets, [:project_id, :scoped_id]
  end
end

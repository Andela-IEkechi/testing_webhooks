class RemoveBodyFromTicket < ActiveRecord::Migration
  def up
    remove_column :tickets, :body
  end

  def down
    add_column :tickets, :body, :text
  end
end

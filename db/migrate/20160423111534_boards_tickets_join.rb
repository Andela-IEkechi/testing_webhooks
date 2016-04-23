class BoardsTicketsJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :boards_tickets, id: false do |t|
      t.belongs_to :board, null: false
      t.belongs_to :ticket, null: false
    end
    add_index :boards_tickets, [:board_id, :ticket_id]    
  end
end

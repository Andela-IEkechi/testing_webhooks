class BoardsTicketsJoin < ActiveRecord::Migration[5.0]
  def change
    create_join_table :boards, :tickets do |t|
      t.index :board_id
      t.index :ticket_id
    end      
  end
end

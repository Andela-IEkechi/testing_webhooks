class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.belongs_to :project
      t.belongs_to :board, null: true
      t.datetime :due_at
      t.string :title, null: false
      t.timestamps
    end
  end
end

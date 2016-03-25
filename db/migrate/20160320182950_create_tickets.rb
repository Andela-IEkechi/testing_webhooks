class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.belongs_to :project
      t.datetime :due_at
      t.string :title, null: false
      t.integer :order, null: false, default: 0
      t.belongs_to :comment, null: true #split from this comment
      t.timestamps
    end
  end
end

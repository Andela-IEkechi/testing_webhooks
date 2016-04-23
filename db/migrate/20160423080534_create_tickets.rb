class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.belongs_to :project, null: false
      t.belongs_to :parent, null: true
      t.integer :sequential_id, null: false
      t.timestamps
    end
  end
end

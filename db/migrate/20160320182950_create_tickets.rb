class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.belongs_to :project
      t.datetime :due_at
      t.timestamps
    end
  end
end

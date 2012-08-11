class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :project, :null => false
      t.string :title, :null => false
      t.timestamps
    end
  end
end

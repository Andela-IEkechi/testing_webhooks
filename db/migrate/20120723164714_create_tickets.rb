class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title, :null => false
      t.text  :body
      t.references :project, :null => false
      t.references :feature
      t.integer :cost
      t.timestamps
    end
  end
end

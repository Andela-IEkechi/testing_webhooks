class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title, :null => false
      t.text  :body
      t.references :ticket, :null => false
      t.references :feature
      t.references :sprint
      t.references :assignee
      t.references :status
      t.integer :cost, :default => 0
      t.references :user, :null => false
      t.timestamps
    end
  end
end

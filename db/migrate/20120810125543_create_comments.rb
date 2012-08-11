class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :ticket, :null => false
      t.references :feature
      t.references :sprint
      t.references :assignee
      t.references :status
      t.text  :body
      t.integer :cost, :default => 0
      t.references :user, :null => false
      t.timestamps
    end
  end
end

class AddIndexToComments < ActiveRecord::Migration
  def change
    add_index :comments, :sprint_id
    add_index :comments, :ticket_id
    add_index :comments, :feature_id
    add_index :comments, :assignee_id
    add_index :comments, :status_id
  end
end

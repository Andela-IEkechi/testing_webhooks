# Add a 'deleted_at' column to allow soft-deletion of users

class AddDeletedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :timestamp
  end
end

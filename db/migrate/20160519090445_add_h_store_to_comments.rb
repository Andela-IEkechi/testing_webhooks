class AddHStoreToComments < ActiveRecord::Migration[5.0]
  def up
    execute "create extension hstore"
    add_column :comments, :tracked_changes, :hstore
  end

  def down
    remove_column :comments, :tracked_changes
  end
end

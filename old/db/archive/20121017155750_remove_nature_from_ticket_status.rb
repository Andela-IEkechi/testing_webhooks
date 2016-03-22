class RemoveNatureFromStatus < ActiveRecord::Migration
  def up
    remove_column :statuses, :nature
  end

  def down
    add_column :statuses, :nature, :string, :default => 'undefined'
  end
end

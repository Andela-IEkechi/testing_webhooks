class AddOpenToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :open, :boolean, :default => true
  end
end

class AddSortIndexToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :sort_index, :integer
  end
end

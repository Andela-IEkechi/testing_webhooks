class RemoveSprintDurationFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :sprint_duration
  end

  def down
    add_column :projects, :sprint_duration, :integer, :default => 5
  end
end

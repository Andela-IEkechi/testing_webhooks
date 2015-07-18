class RenameSprintTitleToGoal < ActiveRecord::Migration
  def up
    rename_column :sprints, :title, :goal
  end

  def down
  end
end

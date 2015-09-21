class RemoveProjectFeaturesSequence < ActiveRecord::Migration
  def up
    remove_column :projects, :features_sequence
  end

  def down
    add_column :projects, :features_sequence, :integer, :default => 0
  end
end

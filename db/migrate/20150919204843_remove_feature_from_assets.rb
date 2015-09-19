class RemoveFeatureFromAssets < ActiveRecord::Migration
  def up
    remove_column :assets, :feature_id
  end

  def down
    add_column :assets, :feature_id, :integer
  end
end

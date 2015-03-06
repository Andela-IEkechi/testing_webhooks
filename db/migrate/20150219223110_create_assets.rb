class CreateAssets < ActiveRecord::Migration
  def up
    add_column :comment_assets, :project_id, :integer, :null => true #temporarily
    add_column :comment_assets, :sprint_id, :integer, :null => true
    add_column :comment_assets, :feature_id, :integer, :null => true
    add_column :comment_assets, :scoped_id, :integer, :default => 0

    add_column :projects, :assets_sequence, :integer, :default => 0

    rename_table :comment_assets, :assets
    add_index :assets, :project_id

    Asset.reset_column_information

    #associate all current comment_assets with their projects
    Asset.find_each do |asset|
      if asset.comment
        asset.project_id = asset.comment.project.id
        asset.save
      end
    end

    #reset scoped ids
    Project.find_each do |project|
      last_asset_id = (project.assets.order('id ASC').last.id rescue 0)
      project.assets_sequence = last_asset_id
      project.save!

      project.assets.all.each_with_index do |asset,index|
        asset.scoped_id = index + 1
        asset.save!
      end
    end

    change_column :assets, :project_id, :integer, :null => false
    change_column :assets, :comment_id, :integer, :null => true
  end

  def down
    remove_column :projects, :assets_sequence
    remove_index :assets, :project_id

    change_column :assets, :comment_id, :integer, :null => false
    remove_column :assets, :project_id
    remove_column :assets, :sprint_id
    remove_column :assets, :feature_id
    remove_column :assets, :scoped_id

    rename_table :assets, :comment_assets
  end
end




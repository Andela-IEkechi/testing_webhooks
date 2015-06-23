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

    #associate all current assets with their projects
    p "Associating existing assets with projects... "
    Asset.find_each do |asset|
      #if there is no project, we are forced to remove the asset and the orphaned comment

      if asset.comment && asset.comment.project
        # p "setting project for asset #{asset.id}, project #{asset.comment.project}"
        asset.project_id = asset.comment.project.id
        asset.save
      elsif asset.comment && asset.comment.project.nil?
        p "destroying comment #{asset.comment.id} for asset #{asset.id}"
        asset.comment.destroy
        asset.destroy
      elsif asset.comment.nil?
        p "destroying asset #{asset.id}"
        asset.destroy
      end
    end

    #reset scoped ids
    p "Setting scoped asset ids for"
    Project.find_each do |project|
      p "... #{project}"
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




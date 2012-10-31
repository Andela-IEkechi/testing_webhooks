class RenameAssetFile < ActiveRecord::Migration
  def up
    rename_column :comment_assets, :file, :payload
  end

  def down
    rename_column :comment_assets, :payload, :file
  end
end

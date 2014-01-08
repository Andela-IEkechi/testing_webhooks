class AddFilesizeToAssets < ActiveRecord::Migration
  def up
    add_column :comment_assets, :filesize, :integer
    Comment::Asset.reset_column_information
    Comment::Asset.find_each do |asset|
      asset.save
    end
  end

  def down
    remove_column :comment_assets, :filesize
  end
end

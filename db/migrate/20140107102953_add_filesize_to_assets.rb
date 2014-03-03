class AddFilesizeToAssets < ActiveRecord::Migration
  def up
    add_column :comment_assets, :filesize, :integer
    Comment::Asset.reset_column_information
    p "storing existing asset file sizes..."
    Comment::Asset.find_each do |asset|
      asset.save
    end
    p "done."
  end

  def down
    remove_column :comment_assets, :filesize
  end
end

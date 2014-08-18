class AddFilesizeToAssets < ActiveRecord::Migration
  def up
    add_column :comment_assets, :filesize, :integer, :default => 0
    Comment::Asset.reset_column_information
    say_with_time "storing existing asset file sizes for #{Comment::Asset.count} assets..." do
    Comment::Asset.each do |asset|
      p asset
      assets.each(&:save)
    end
  end

  def down
    remove_column :comment_assets, :filesize
  end
end

class ChangeFileToPayload < ActiveRecord::Migration
  def change
    if column_exists?(:comment_assets, :file) && !column_exists?(:comment_assets, :payload)
      rename_column :comment_assets, :file, :payload
    end
  end
end

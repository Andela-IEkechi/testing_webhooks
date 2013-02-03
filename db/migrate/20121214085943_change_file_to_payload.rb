class ChangeFileToPayload < ActiveRecord::Migration
  def change
    rename_column :comment_assets, :file, :payload
  end
end

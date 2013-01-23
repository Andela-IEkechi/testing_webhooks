class AddPayloadToAssets < ActiveRecord::Migration
  def change
    Comment::Asset.reset_column_information
    add_column(:comment_assets, :payload, :string) unless Comment::Asset.column_names.include?('profile')
  end
end

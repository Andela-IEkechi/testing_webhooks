class AddPayloadToAssets < ActiveRecord::Migration
  def change
    Comment::Assets.reset_column_information
    add_column(:comment_assets, :payload, :string) unless Comment::Assets..column_names.include?('profile')
  end
end

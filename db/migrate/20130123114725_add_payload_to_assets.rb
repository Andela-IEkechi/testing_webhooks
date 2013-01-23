class AddPayloadToAssets < ActiveRecord::Migration
  def change
    add_column :comment_assets, :payload, :string
  end
end

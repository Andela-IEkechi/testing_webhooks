class AddPayloadExistsToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :payload_exists, :boolean, :default => true
  end
end

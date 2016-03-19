class ChangeAssetPayloadExistsToPayloadSize < ActiveRecord::Migration
  def up
    remove_column :assets, :payload_exists
    add_column :assets, :payload_size, :integer, :default => 0
  end

  def down
    add_column :assets, :payload_exists, :boolean, :default => true
    remove_column :assets, :payload_size
  end
end

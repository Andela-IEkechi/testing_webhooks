class CreateAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :assets do |t|
      t.belongs_to :assetable, polymorphic: true
      t.string :payload
      t.string :payload_size
      t.string :payload_size
      t.timestamps
    end
  end
end

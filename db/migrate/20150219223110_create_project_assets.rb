class CreateProjectAssets < ActiveRecord::Migration
  def change
    create_table :project_assets do |t|
      t.belongs_to :project,                :null => false
      t.belongs_to :sprint,                :null => true
      t.belongs_to :feature,                :null => true
      t.string   "payload"
      t.integer  "filesize",   :default => 0
      t.timestamps
      t.integer :scoped_id, :default => 0
    end

    add_column :projects, :asset_sequence, :integer, :default => 0
    add_index :project_assets, :project_id
  end
end

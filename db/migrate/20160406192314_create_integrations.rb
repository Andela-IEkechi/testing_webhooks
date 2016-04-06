class CreateIntegrations < ActiveRecord::Migration[5.0]
  def change
    create_table :integrations do |t|
      t.belongs_to :user
      t.string :party, null: false
      t.string :key, null: false
      t.boolean :enabled, default: false
      t.timestamps
    end
  end
end

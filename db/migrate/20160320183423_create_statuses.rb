class CreateStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :statuses do |t|
      t.belongs_to :project
      t.string :name, null: false
      t.boolean :open, null: false, default: true
      t.integer :order
      t.timestamps
    end
  end
end

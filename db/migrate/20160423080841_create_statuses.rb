class CreateStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :statuses do |t|
      t.belongs_to :project, null: false
      t.string :name, null: false
      t.integer :order, default: 0
      t.boolean :open, default: true
      t.timestamps
    end
  end
end

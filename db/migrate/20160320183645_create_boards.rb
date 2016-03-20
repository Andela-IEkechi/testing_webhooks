class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.belongs_to :project
      t.string :name, null: false
      t.timestamps
    end
  end
end

class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.belongs_to :project, null: false
      t.belongs_to :user, null: false
      t.string :role, null: false
      t.boolean :confirmed, dafault: false
      t.timestamps
    end
  end
end

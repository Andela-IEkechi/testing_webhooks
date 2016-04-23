class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :slug, uniq: true
      t.string :logo_id
      t.timestamps
    end
  end
end

class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name, :null => false
      t.string :description, :null => true
      t.timestamps

      t.string :logo
      t.integer :logo_size
      t.string :logo_content_type
    end
  end
end

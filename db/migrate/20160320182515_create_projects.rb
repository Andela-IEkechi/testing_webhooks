class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title, :null => false
      t.string :description, :null => true
      t.timestamps
    end
  end
end

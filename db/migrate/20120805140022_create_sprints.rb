class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.date :due_on, :null => false
      t.string :title, :null => false
      t.references :project, :null => false
      t.timestamps
    end
  end
end

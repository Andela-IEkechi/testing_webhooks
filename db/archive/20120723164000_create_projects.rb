class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
    	t.string :title, :null => false
    	t.integer :sprint_duration, :default => 5
    	t.string :api_key, :null => false
      t.timestamps
    end
  end
end
#add user id - owner of the projects
#add sprint duration
#add api_key
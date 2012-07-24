class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
    	t.string :title, :null => false
    	t.string :description
    	t.date :due_on
    	t.references :project, :null => false
      t.timestamps
    end
  end
end

class DropFeaturesTable < ActiveRecord::Migration
  def up
    drop_table :features

  end

  def down
    create_table "features", :force => true do |t|
      t.string   "title",                      :null => false
      t.string   "description"
      t.date     "due_on"
      t.integer  "project_id",                 :null => false
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
      t.integer  "scoped_id",   :default => 0
    end

    add_index "features", ["project_id"], :name => "index_features_on_project_id"
  end
end

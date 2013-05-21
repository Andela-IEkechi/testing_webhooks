class CreateOverviews < ActiveRecord::Migration
  def change
    create_table :overviews do |t|
      t.string :title, :null =>  false
      t.string :filter, :default => '', :null => false
      t.belongs_to :user, :null => false
      t.timestamps
    end

    create_table :overviews_projects, :id => false do |t|
      t.belongs_to :overview
      t.belongs_to :project
    end
  end
end

class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :project, :null => false
      t.string :name, :null => false
      t.string :nature, :null => false
    end

    change_table :tickets do |t|
      t.references :status
    end
  end
end

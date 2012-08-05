class AddCostToTask < ActiveRecord::Migration
  def change
    change_table :tickets do |t|
      t.integer :cost, :default => 0
    end
  end
end

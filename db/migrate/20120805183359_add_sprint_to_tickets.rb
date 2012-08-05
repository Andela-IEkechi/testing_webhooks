class AddSprintToTickets < ActiveRecord::Migration
  def change
    change_table :tickets do |t|
      t.references :sprint
    end
  end
end

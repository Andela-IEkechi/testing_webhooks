class AddStatusToTicket < ActiveRecord::Migration
  def change
    change_table :tickets do |t|
      t.references :status, :null => false
    end
  end
end

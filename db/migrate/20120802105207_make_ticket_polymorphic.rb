class MakeTicketPolymorphic < ActiveRecord::Migration
  def up
    change_table :tickets do |t|
      t.references :ticketable, :polymorphic => true, :null => false
    end
    remove_column :tickets, :feature_id
  end

  def down
    remove_column :tickets, :ticketable_type
    remove_column :tickets, :ticketable_id
  end
end

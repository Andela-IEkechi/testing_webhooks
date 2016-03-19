class AddStartedOnToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :started_on, :date
  end
end

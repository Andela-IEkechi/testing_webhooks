class AddBlockedToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :blocked, :boolean, :default => false
  end
end

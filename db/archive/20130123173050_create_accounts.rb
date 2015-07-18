class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user
      t.string     :plan,    :default => "free"
      t.boolean    :enabled, :default => true

      t.timestamps
    end
    add_index :accounts, :user_id
  end
end

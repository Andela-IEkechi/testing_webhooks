class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :user
      t.string :plan
      t.timestamps
    end
  end
end

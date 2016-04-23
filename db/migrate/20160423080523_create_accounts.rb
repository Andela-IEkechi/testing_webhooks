class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :user, null: false
      t.date :anniversary_on
      t.timestamps
    end
  end
end

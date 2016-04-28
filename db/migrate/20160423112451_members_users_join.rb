class MembersUsersJoin < ActiveRecord::Migration[5.0]
  def change
    create_join_table :members, :users do |t|
      t.index :member_id
      t.index :user_id
    end      
  end
end

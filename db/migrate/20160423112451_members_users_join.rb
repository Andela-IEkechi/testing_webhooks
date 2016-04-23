class MembersUsersJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :members_users, id: false do |t|
      t.belongs_to :member, null: false
      t.belongs_to :user, null: false
    end
    add_index :members_users, [:member_id, :user_id]    
  end
end

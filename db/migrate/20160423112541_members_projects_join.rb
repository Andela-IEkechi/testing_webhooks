class MembersProjectsJoin < ActiveRecord::Migration[5.0]
  def change
    create_join_table :members, :projects do |t|
      t.index :project_id
      t.index :member_id
    end
  end
end

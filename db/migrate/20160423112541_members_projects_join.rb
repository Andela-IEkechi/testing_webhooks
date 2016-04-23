class MembersProjectsJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :members_projects, id: false do |t|
      t.belongs_to :member, null: false
      t.belongs_to :project, null: false
    end
    add_index :members_projects, [:member_id, :project_id]    
  end
end

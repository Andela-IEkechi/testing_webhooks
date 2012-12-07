class CreateMemberships < ActiveRecord::Migration

  def up
    create_table :memberships do |t|
      t.references :project
      t.references :user
      t.boolean :is_admin, :null => false, :default => false
    end

    # Use the existing data from project_users to populate memberships
    execute <<-SQL
      INSERT INTO memberships (project_id, user_id, is_admin)
      SELECT project_id, user_id, true FROM projects_users
    SQL

  end

  def down
    drop_table :memberships
  end

end

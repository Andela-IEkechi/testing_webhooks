class CreateMemberships < ActiveRecord::Migration

  def up
    create_table :memberships do |t|
      t.references :project
      t.references :user
      t.string :role, :null => false, :default => 'regular'
    end

    # Use the existing data from project_users to populate memberships
    execute <<-SQL
      INSERT INTO memberships (project_id, user_id, role)
      SELECT pu.project_id, pu.user_id, 'admin' FROM projects_users pu, projects p
      WHERE p.id = pu.project_id AND p.user_id = pu.user_id
    SQL
    execute <<-SQL
      INSERT INTO memberships (project_id, user_id, role)
      SELECT pu.project_id, pu.user_id, 'regular' FROM projects_users pu, projects p
      WHERE p.id = pu.project_id AND p.user_id <> pu.user_id
    SQL

    drop_table :projects_users
  end

  def down
    create_table :projects_users do |t|
      t.references :project
      t.references :user
    end

    # Use the existing data from memberships to populate project_users
    execute <<-SQL
      INSERT INTO projects_users (project_id, user_id)
      SELECT project_id, user_id FROM memberships
    SQL

    drop_table :memberships
  end

end

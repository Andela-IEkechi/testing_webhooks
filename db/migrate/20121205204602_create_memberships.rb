class CreateMemberships < ActiveRecord::Migration

  def up
    create_table :memberships do |t|
      t.references :project
      t.references :user
      t.string :role, :null => false, :default => 'Regular'
    end

    # Use the existing data from project_users to populate memberships
    execute <<-SQL
      INSERT INTO memberships (project_id, user_id, role)
      SELECT project_id, user_id, 'Admin' FROM projects_users
    SQL

  end

  def down
    drop_table :memberships
  end

end

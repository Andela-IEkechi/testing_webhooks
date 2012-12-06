class CreateMemberships < ActiveRecord::Migration
  def change
    rename_table 'projects_users', 'memberships'
    add_column :memberships, :is_admin, :boolean, :null => false, :default => false
  end
end

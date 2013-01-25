class RemoveApiKeyFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :api_key
  end

  def down
    add_column :projects, :api_key, :string, :null => false
  end
end

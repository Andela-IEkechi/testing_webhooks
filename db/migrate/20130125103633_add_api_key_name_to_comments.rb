class AddApiKeyNameToComments < ActiveRecord::Migration
  def change
    add_column :comments, :api_key_name, :string
    add_index :comments, :api_key_name, :unique => true
  end
end

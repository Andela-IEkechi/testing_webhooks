class AddApiKeyNameToComments < ActiveRecord::Migration
  def change
    add_column :comments, :api_key_name, :string
  end
end

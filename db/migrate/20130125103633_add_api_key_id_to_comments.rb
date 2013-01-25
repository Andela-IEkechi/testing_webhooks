class AddApiKeyIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :api_key_id, :integer
  end
end

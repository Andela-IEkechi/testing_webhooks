class AddCommitUuidToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :commit_uuid, :string
    add_column :comments, :api_key_name, :string
  end
end

class CreateRefileAttachments < ActiveRecord::Migration
  def change
    create_table :refile_attachments do |t|
      t.string :namespace, null: false
    end
    add_index :refile_attachments, :namespace
  end
end


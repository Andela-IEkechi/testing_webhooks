class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.belongs_to :comment, null: false
      t.string :file_id
      t.timestamps
    end
  end
end

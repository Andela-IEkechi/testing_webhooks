class StoreAttachmentMetaData < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :file_filename, :string
    add_column :attachments, :file_size, :integer
    add_column :attachments, :file_content_type, :string
  end
end

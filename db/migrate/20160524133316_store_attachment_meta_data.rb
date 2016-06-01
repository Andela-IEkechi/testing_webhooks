class StoreAttachmentMetaData < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :file_filename, :string
  end
end

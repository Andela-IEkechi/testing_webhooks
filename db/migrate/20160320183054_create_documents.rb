class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.belongs_to :documentable, polymorphic: true
      t.timestamps
      t.string :file
      t.integer :file_size
      t.string :file_content_type
    end
  end
end

class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.belongs_to :ticket
      t.belongs_to :user
      t.text :content
      t.timestamps
    end
  end
end

class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.belongs_to :ticket, null: false
      t.belongs_to :commenter, null: true
      t.belongs_to :status, null: true
      t.belongs_to :assignee_id, null: true      
      t.text :message
      t.timestamps
    end
  end
end

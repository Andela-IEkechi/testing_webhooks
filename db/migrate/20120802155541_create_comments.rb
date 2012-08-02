class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :ticket, :null => false
      t.references :status
      t.text :body
      t.timestamps
    end
  end

end

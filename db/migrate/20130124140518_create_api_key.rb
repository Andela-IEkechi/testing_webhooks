class CreateApiKey < ActiveRecord::Migration
  def change
    create_table :api_keys, {:id => false} do |t|
      t.string :name, :null => false
      t.string :token, :null => false
      t.references :project
      t.timestamps
    end
    #add_index :api_keys, :name, :unique => true
  end
end

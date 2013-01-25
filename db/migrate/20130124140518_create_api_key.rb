class CreateApiKey < ActiveRecord::Migration
  def change
    create_table :api_keys, {:primary_key => :name} do |t|
      t.string :name, :null => false
      t.string :token, :null => false
      t.references :project
      t.timestamps
    end
  end
end

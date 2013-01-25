class CreateApiKey < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.references :project
      t.string :name, :null => false
      t.string :token, :null => false
      t.timestamps
    end
  end
end

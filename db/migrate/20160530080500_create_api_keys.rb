class CreateApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :api_keys do |t|
      t.string :name
      t.string :access_key
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end

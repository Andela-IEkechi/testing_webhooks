class CreateOverviews < ActiveRecord::Migration[5.0]
  def change
    create_table :overviews do |t|
      t.belongs_to :user
      t.string :title, null: false
      t.text :criteria, default: "--{}"
      t.timestamps
    end
  end
end

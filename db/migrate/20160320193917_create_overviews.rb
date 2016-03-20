class CreateOverviews < ActiveRecord::Migration[5.0]
  def change
    create_table :overviews do |t|

      t.timestamps
    end
  end
end

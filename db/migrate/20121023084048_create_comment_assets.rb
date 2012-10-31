class CreateCommentAssets < ActiveRecord::Migration
  def change
    create_table :comment_assets do |t|
      t.references :comment, :null => false
      t.string :file
      t.timestamps
    end
  end
end

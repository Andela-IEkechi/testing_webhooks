class AddRenderedBodyToComments < ActiveRecord::Migration
  def change
     add_column :comments, :rendered_body, :text
     Comment.reset_column_information
     Comment.all.each{|c| c.save!}
  end
end

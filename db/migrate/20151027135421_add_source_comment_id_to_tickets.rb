class AddSourceCommentIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :source_comment_id, :integer
  end
end

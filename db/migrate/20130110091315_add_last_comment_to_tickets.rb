class AddLastCommentToTickets < ActiveRecord::Migration
  def up
    add_column :tickets, :last_comment_id, :integer

    Ticket.reset_column_information

    Ticket.find_each do |ticket|
      ticket.last_comment = ticket.comments.last
      ticket.save
    end
  end

  def down
    remove_column :tickets, :last_comment_id
  end
end

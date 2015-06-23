class CleanOrphanedComments < ActiveRecord::Migration
  def up
    Comment.includes(:ticket).find_each {|c|
      c.destroy if c.ticket.nil?
    }
  end

  def down
  end
end

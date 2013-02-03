class ResetGitComments < ActiveRecord::Migration
  def up
    Comment.find_each do |comment|
      if !comment.commenter.blank?
        comment.user = nil
        comment.save
      end
    end
  end

  def down
  end
end

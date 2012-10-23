class Comment::Asset < ActiveRecord::Base
  # attr_accessible :title, :body

  validates :comment_id, :presence => true
end

class Comment::Asset < ActiveRecord::Base
  belongs_to :comment
  has_one :ticket, :through => :comment

  # attr_accessible :title, :body

  validates :comment_id, :presence => true
end

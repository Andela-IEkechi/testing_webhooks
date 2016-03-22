class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :board, optional: true

  has_many :comments, dependent: :destroy

  # has_many :assets, :through => :comments
  # has_many :split_tickets, :order => 'tickets.id ASC', :through => :comments

  validates :title, :length => {:minimum => 3}

  def last_comment
    comments.order(id: :asc).last
  end

  def first_comment
    comments.order(id: :asc).first
  end

  delegate :assignee, :to => :last_comment, :prefix => false, :allow_nil => true
  delegate :status, :to => :last_comment, :prefix => false
  delegate :user, :to => :first_comment, :prefix => false

end

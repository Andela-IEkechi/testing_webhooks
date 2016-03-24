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

  #move a ticket to a new status and attribute the move to the user provided
  def move!(status, user)
    #check if the status provided is in the current project
    return unless status.project == self.project

    #check if the user is on the project
    return unless self.project.has_member(user)

    #move the ticket to the new status, by adding a comment to the ticket
    self.comments.create(user_id: user.id, status_id: status.id)
    #possibly need to reload to refresh the interpretation of last_comment
    self.reload
  end

  def broadcast_data
    self.as_json(include: [:status, :assignee, :user])
  end
end

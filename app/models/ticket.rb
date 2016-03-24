class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :board, optional: true

  has_many :comments, dependent: :destroy

  # has_many :assets, :through => :comments
  # has_many :split_tickets, :order => 'tickets.id ASC', :through => :comments

  validates :title, :length => {:minimum => 3}

  scope :for_status, ->(status){joins(project: :statuses).where(statuses: {id: status.id})}
  scope :ordered, ->{reorder(order: :asc)}

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
  def move!(status, order, user)
    #check if the status provided is in the current project
    return unless status.project == project

    #check if the user is on the project
    return unless project.has_member(user)

    #move the ticket to the new status, by adding a comment to the ticket
    comments.create(user_id: user.id, status_id: status.id)

    reorder!(order)
    #possibly need to reload to refresh the interpretation of last_comment
    reload
    self
  end

  def broadcast_data
    as_json(include: [:status, :assignee, :user])
  end

  private

  #place this ticket in a new relative position in the status for it's board
  def reorder!(order)
    #get all the tickets in their current order, by board and status
    #exclude ourselves
    tickets = board.tickets.for_status(status).ordered.where.not(id: id).to_a

    #stick this ticket into the right place
    tickets.insert(order, self)

    #save all the tickets in their new order
    tickets.each_with_index do |ticket, idx|
      ticket.update_column(:order, idx)
    end
    self
  end
end

class Ticket < ApplicationRecord
  has_paper_trail
  include Broadcast::Ticket

  belongs_to :project

  belongs_to :comment, optional: true #we are split off from this comment
  has_many :comments, dependent: :destroy

  has_many :documents, through: :comments
  has_many :tickets, through: :comments, source: "ticket"

  validates :name, length: {minimum: 3}

  accepts_nested_attributes_for :comments, allow_destroy: true

  scope :ordered, ->{reorder(order: :asc)}

  scope :for_status, ->(status){ joins(:comments).
    where(comments: {last: true}).
    where(comments: {status_id: (status.id rescue nil)}) }
  scope :for_cost, ->(cost){ joins(:comments).
    where(comments: {last: true}).
    where(comments: {cost: cost}) }
  scope :for_assignee, ->(assignee){ joins(:comments).
    where(comments: {last: true}).
    where(comments: {assignee_id: assignee.id}) }
  scope :for_user, ->(user){ joins(:comments).
    where(comments: {last: true}).
    where(comments: {user_id: (user.id rescue nil)}) }
  scope :for_board, ->(board){ joins(:comments).
    where(comments: {last: true}).
    where(comments: {board_id: (board.id rescue nil)}) }

  accepts_nested_attributes_for :comments, allow_destroy: true

  #Make sure only one comment is marked as being the last
  def set_last_comment!
    return unless last_comment.present?
    comments.where(last: true).update_all(last: false)
    last_comment.update_column(:last, true) if last_comment.present?
  end

  def last_comment
    last = comments.order(id: :asc).last
  end

  def first_comment
    comments.order(id: :asc).first
  end

  delegate :assignee, :to => :last_comment, :prefix => false, :allow_nil => true
  delegate :status, :to => :last_comment, :prefix => false, :allow_nil => true
  delegate :user, :to => :first_comment, :prefix => false, :allow_nil => true
  delegate :board, :to => :last_comment, :prefix => false, :allow_nil => true
  delegate :cost, :to => :last_comment, :prefix => false, :allow_nil => true
  delegate :cost_key, :to => :last_comment, :prefix => false, :allow_nil => true

  #move a ticket to a new status and attribute the move to the user provided
  def move!(status, order, user)
    #check if the status provided is in the current project
    return unless status.project == project
    #check if the user is on the project
    return unless project.has_member?(user)
    #move the ticket to the new status, by adding a comment to the ticket
    # be sure to preserve previsous comment values for cost, assignee and board

    #only create a comment if the ticket moved status
    unless status.id == self.status.id
      comments.create(
        user_id: user.id,
        status_id: status.id,
        cost: (cost rescue nil),
        board_id: (board.id rescue nil),
        assignee_id: (assignee.id rescue nil)
      )
    end

    # we always re-order, it's the minimum change
    reorder!(order)
    #possibly need to reload to refresh the interpretation of last_comment
    reload
    broadcast_update
    self
  end

  private

  #place this ticket in a new relative position in the status for it's board
  def reorder!(order)
    #get all the tickets in their current order, by board and status
    #exclude ourselves
    tickets = project.tickets.for_board(board).for_status(status).ordered.where.not(id: id).to_a.compact

    #stick this ticket into the right place, this will insert preceeding nils if required
    tickets.insert(order, self).compact!

    #save all the tickets in their new order
    tickets.each_with_index do |ticket, idx|
      ticket.update_column(:order, idx)
    end
    self
  end

end

class Comment < ActiveRecord::Base
  include Markdownable
  after_create :update_ticket

  belongs_to :ticket #always
  belongs_to :user #the person who made the comment
  has_one    :project, :through => :ticket
  has_many   :assets

  belongs_to :sprint
  belongs_to :feature
  belongs_to :assignee, :class_name => 'User' # the user the ticket is assigned to
  belongs_to :status, :class_name => 'TicketStatus'

  accepts_nested_attributes_for :assets

  attr_accessible :body, :cost, :rendered_body
  attr_accessible :ticket_id, :user_id, :status_id, :feature_id, :sprint_id, :assignee_id, :assets_attributes

  #we can't enforce this in the model, or nested create fails : validates :ticket_id, :presence => true
  validates :user_id, :presence => true
  validates :cost, :inclusion => {:in => Ticket::COST}

  def to_s
    title
  end

  def parent
    sprint || feature || project
  end

  def previous
    return ticket.comments.last if self.new_record?
    ticket.comments.select{|c| c.id < self.id}.last
  end

  def html
    rendered_body || ''
  end

  def only?
    ticket.comments.size == 1
  end

  def first?
    ticket.comments.first.id == self.id
  end

  private

  def update_ticket
    self.ticket.update_last_comment! if self.ticket
  end
end

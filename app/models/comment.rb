class Comment < ActiveRecord::Base
  include Markdownable

  belongs_to :ticket #always
  has_one    :project, :through => :ticket
  belongs_to :feature #optional
  belongs_to :sprint  #optional
  belongs_to :assignee, :class_name => 'User' #optional, who it's assigned to
  belongs_to :status, :class_name => 'TicketStatus'
  belongs_to :user #always, who made the comment
  has_many   :assets

  accepts_nested_attributes_for :assets

  attr_accessible :body, :cost, :rendered_body
  attr_accessible :status_id, :feature_id, :ticket_id, :sprint_id, :user_id, :assignee_id, :assets_attributes

  #we can't enforce this in the model, or nested create fails : validates :ticket_id, :presence => true
  validates :status_id, :presence => true
  validates :user_id, :presence => true
  validates :cost, :inclusion => {:in => Ticket::COST}

  def to_s
    title
  end

  def parent
    sprint || feature || project
  end

  def belongs_to_feature?
    feature != nil
  end

  def belongs_to_sprint?
    sprint != nil
  end

  def is_assigned?
    assignee != nil
  end

  def previous
    return ticket.comments.last if self.new_record?
    ticket.comments.select{|c| c.id < self.id}.last
  end

  def html
    rendered_body || ''
  end
end

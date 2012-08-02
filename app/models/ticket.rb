class Ticket < ActiveRecord::Base
  belongs_to :ticketable, :polymorphic => true
  belongs_to :status, :class_name => 'TicketStatus'
  has_many   :comments, :order => :id

  attr_accessible :title, :body, :status_id, :comments_attributes, :status
  accepts_nested_attributes_for :comments

  validates :title, :presence => true
  validates :ticketable_type, :presence => true
  validates :ticketable_id, :presence => true
  validates :status_id, :presence => true

  def to_s
    title
  end

  #the status of the most recent comment
  def current_status
    (comments.count > 0) && comments.with_status.last.status || status
  end
end

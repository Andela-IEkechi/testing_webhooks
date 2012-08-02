class Ticket < ActiveRecord::Base
  belongs_to :ticketable, :polymorphic => true
  belongs_to :status, :class_name => 'TicketStatus'

  attr_accessible :title, :body, :status_id

  validates :title, :presence => true
  validates :ticketable_type, :presence => true
  validates :ticketable_id, :presence => true
  validates :status_id, :presence => true

  def to_s
    title
  end
end

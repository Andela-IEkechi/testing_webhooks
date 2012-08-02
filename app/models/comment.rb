class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :status, :class_name => 'TicketStatus'

  attr_accessible :body, :ticket_id, :status_id, :status

  validates :ticket_id, :presence => true

  scope :with_status, lambda { {:conditions => ["status_id IS NOT NULL"]} }

end

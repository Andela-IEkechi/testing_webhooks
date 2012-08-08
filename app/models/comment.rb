class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :status, :class_name => 'TicketStatus'
  has_one :feature, :through => :ticket
  has_one :sprint, :through => :ticket

  attr_accessible :body, :ticket_id, :status_id

  #we use these to the ticket values for sprint and feature from a new comment
  attr_accessor :feature_id, :sprint_id
  attr_accessible :feature_id, :sprint_id
  after_create :set_ticket_values

  validates :ticket_id, :presence => true

  scope :with_status, lambda { {:conditions => ["status_id IS NOT NULL"]} }

  private
  def set_ticket_values
    p "feature_id: #{feature_id}"
    p "sprint_id: #{sprint_id}"
    self.ticket.feature_id = feature_id
    self.ticket.sprint_id = sprint_id
    p "setting sprint #{self.ticket.sprint_id}, feature #{self.ticket.feature_id} "
    self.ticket.save!
  end
end

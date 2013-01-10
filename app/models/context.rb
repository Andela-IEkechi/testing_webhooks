class Context < ActiveRecord::Base
  belongs_to :contextable, :polymorphic => true

  belongs_to :sprint
  belongs_to :feature
  belongs_to :assignee, :class_name => 'User'
  belongs_to :status, :class_name => 'TicketStatus'

  attr_accessible :status_id, :feature_id, :sprint_id, :assignee_id

  scope :for_ticket, where (:contextable_type => 'Ticket')
  scope :for_comment, where (:contextable_type => 'Comment')

end

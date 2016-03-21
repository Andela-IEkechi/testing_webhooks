class TicketStatus < ApplicationRecord
  belongs_to :project

  SYSTEM={
    open: ['new', 'open', 'on hold'],
    closed: ['closed', 'invalid']
  }

  validates :name, presence: true, uniqueness: {scope: :project_id}

  scope :open,   ->{where(open: true)}
  scope :closed, ->{where(open: false)}
end

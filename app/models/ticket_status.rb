class TicketStatus < ActiveRecord::Base
  belongs_to :project
  has_many :tickets, :foreign_key => 'status_id'
  before_destroy :check_for_tickets

  attr_accessible :name, :nature #cant use "type"

  NATURES = ['open', 'closed']

  validates :name, :presence => true, :uniqueness => {:scope => :project_id}
  validates :project_id, :presence => true
  validates :nature, :inclusion => {:in => NATURES}

  def to_s
    name
  end

  private

  def check_for_tickets
    if tickets.count > 0
      errors.add(:base, "cannot delete a ticket status while tickets refer to it")
      return false
    end
  end
end

class TicketStatus < ActiveRecord::Base
  belongs_to :project
  has_many :tickets, :foreign_key => 'status_id'
  before_destroy :check_for_tickets

  attr_accessible :name, :nature, :open #cant use "type"

  validates :name, :presence => true, :uniqueness => {:scope => :project_id}
  validates :project_id, :presence => true

  def to_s
    name
  end

  def close!
    self.open = false
    self.save!
  end

  def open!
    self.open = true
    self.save!
  end

  private

  def check_for_tickets
    if tickets.count > 0
      errors.add(:base, "cannot delete a ticket status while tickets refer to it")
      return false
    end
  end
end

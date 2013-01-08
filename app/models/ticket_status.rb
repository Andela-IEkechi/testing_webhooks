class TicketStatus < ActiveRecord::Base
  belongs_to :project
  has_many :comments, :foreign_key => 'status_id'
  #has_many :tickets, :through => :comments
  before_destroy :check_for_tickets

  attr_accessible :name, :open #cant use "type"

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
    if comments && comments.count > 0
      errors.add(:base, "cannot delete a ticket status while comments refer to it")
      return false
    end
  end
end

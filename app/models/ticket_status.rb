class TicketStatus < ActiveRecord::Base
  belongs_to :project
  has_many :tickets, :foreign_key => 'status_id'
  has_many :comments, :foreign_key => 'status_id'
  before_destroy :check_for_tickets, :check_for_comments

  attr_accessible :name

  validates :name, :presence => true, :uniqueness => {:scope => :project_id}
  validates :project_id, :presence => true

  def to_s
    name
  end

  private

  def check_for_tickets
    if tickets.count > 0
      errors.add(:base, "cannot delete ticket status while tickets exist")
      return false
    end
  end
  def check_for_comments
    if comments.count > 0
      errors.add(:base, "cannot delete ticket status while comments exist")
      return false
    end
  end
end

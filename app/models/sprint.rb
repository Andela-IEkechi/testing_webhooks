class Sprint < ActiveRecord::Base
  include TicketHolder
  include Scoped

  belongs_to :project #not optional

  attr_accessible :goal, :due_on

  validates :project_id, :presence => true
  validates :goal, :presence => true, :uniqueness => {:scope => :project_id}
  validates :due_on, :presence => true

  default_scope :order => "title ASC"

  def to_s
    goal
  end

  def running?
    Date.today <= due_on.to_date
  end

  def open?
    running? || has_open_tickets?
  end

  def closed?
    !open?
  end

end

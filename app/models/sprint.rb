class Sprint < ActiveRecord::Base
  belongs_to :project #not optional

  include TicketHolder

  attr_accessible :goal, :due_on

  validates :project_id, :presence => true
  validates :goal, :presence => true, :uniqueness => {:scope => :project_id}
  validates :due_on, :presence => true

  def to_s
    goal
  end

  def running?
    Date.today <= due_on
  end

  def has_open_tickets?
    assigned_tickets.collect(&:status).select{|s| s.open}.count>0
  end

  def open?
    running? || has_open_tickets?
  end

  def closed?
    !open?
  end

end

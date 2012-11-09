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

end

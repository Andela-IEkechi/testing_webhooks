class Feature < ActiveRecord::Base
	belongs_to :project #not optional

  include TicketHolder

  attr_accessible :title, :description, :due_on

  validates :project_id, :presence => true
  validates :title, :presence => true, :uniqueness => {:scope => :project_id}

  def to_s
    title
  end

end

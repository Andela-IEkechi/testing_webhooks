class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :tickets

  attr_accessible :name, :due_on

  validates :project_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :project_id}

  def cost
    tickets.sum(&:cost)
  end
end

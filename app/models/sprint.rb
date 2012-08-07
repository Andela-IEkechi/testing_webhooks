class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :tickets #tickets are tied to a project, so we dont destroy them if a sprint is removed

  attr_accessible :name, :due_on

  validates :project_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :project_id}

  def cost
    tickets.sum(&:cost)
  end
end

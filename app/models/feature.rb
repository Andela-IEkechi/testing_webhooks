class Feature < ActiveRecord::Base
	belongs_to :project
  has_many :tickets

  attr_accessible :title, :description, :due_on

  validates :title, :presence => true, :uniqueness => {:scope => :project_id}

  def to_s
    title
  end
end

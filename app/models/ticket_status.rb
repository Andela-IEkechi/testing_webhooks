class TicketStatus < ActiveRecord::Base
  belongs_to :project
  #has_many :tickets, but we dont care about that just yet

  attr_accessible :name

  validates :name, :presence => true, :uniqueness => {:scope => :project_id}
  validates :project_id, :presence => true

  def to_s
    name
  end
end

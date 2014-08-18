class Feature < ActiveRecord::Base
  include TicketHolder
  include Scoped

  belongs_to :project #not optional


  attr_accessible :title, :description, :due_on

  validates :project_id, :presence => true
  validates :title, :presence => true, :uniqueness => {:scope => :project_id}

  default_scope :order => "title ASC"

  def to_s
    title
  end

end

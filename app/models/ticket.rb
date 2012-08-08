class Ticket < ActiveRecord::Base
  belongs_to :project #always
  belongs_to :feature #optional
  belongs_to :sprint  #optional
  belongs_to :user #optional, who it's assigned to

  belongs_to :status, :class_name => 'TicketStatus'

  has_paper_trail

  attr_accessible :title, :body, :cost
  attr_accessible :status_id, :feature_id, :project_id, :sprint_id

  COST = [0,1,2,3]

  validates :title, :presence => true, :length => {:minimum => 3}
  validates :project_id, :presence => true
  validates :status_id, :presence => true
  validates :cost, :inclusion => {:in => COST}

  scope :unassigned, where(:sprint_id => nil, :feature_id => nil)

  def to_s
    title
  end

  def parent
    sprint || feature || project
  end

  def belongs_to_feature?
    feature != nil
  end

  def belongs_to_sprint?
    sprint != nil
  end

  def belongs_to_project?
    project != nil
  end
end

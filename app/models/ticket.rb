class Ticket < ActiveRecord::Base
  belongs_to :project #always
  belongs_to :feature #optional
  belongs_to :sprint  #optional
  belongs_to :user #optional, who it's assigned to

  belongs_to :status, :class_name => 'TicketStatus'
  has_many   :comments, :order => :id, :dependent => :destroy

  attr_accessible :title, :body, :cost, :comments_attributes
  attr_accessible :status_id, :feature_id, :project_id, :sprint_id
  accepts_nested_attributes_for :comments

  COST = [0,1,2,3]

  validates :title, :presence => true, :length => {:minimum => 3}
  validates :project_id, :presence => true
  validates :status_id, :presence => true
  validates :cost, :inclusion => {:in => COST}

  def to_s
    title
  end

  def current_status
    (comments.count > 0) && comments.with_status.last.status || status
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

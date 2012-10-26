class Ticket < ActiveRecord::Base
  belongs_to :project #always
  has_many :comments, :order => :id

  attr_accessible :project_id, :comments_attributes, :title
  accepts_nested_attributes_for :comments

  COST = [1,2,3]

  validates :project_id, :presence => true
  validates :title, :length => {:minimum => 3}

  scope :unassigned, lambda{ parent.is_a? Project}

  def to_s
    title
  end

  def parent
    get_last(:parent) || project
  end

  def body
    get_current(:body)
  end

  def sprint
    get_last(:sprint)
  end

  def sprint_id
    get_last(:sprint) && get_last(:sprint).id || nil
  end

  def feature
    get_last(:feature)
  end

  def feature_id
    get_last(:feature) && get_last(:feature).id || nil
  end

  def assignee
    get_last(:assignee)
  end

  def assignee_id
    get_last(:assignee) && get_last(:assignee).id || nil
  end

  def user
    get_last(:user)
  end

  def user_id
    get_last(:user) && get_last(:user).id || nil
  end

  def status
    get_last(:status)
  end

  def cost
    get_last(:cost)
  end

  private

  #this returns the CURRENTLY SET VALUE, in the history for this ticket
  #ie, the value the last time it was set, even if that was 5 comments ago
  def get_current(attr)
    attr = attr.to_sym
    comments.collect(&attr).compact.last
  end

  #this returns the values as set in the last comment
  def get_last(attr)
    comments.last.try(attr)
  end

end

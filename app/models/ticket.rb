class Ticket < ActiveRecord::Base
  belongs_to :project #always
  has_many :comments, :order => :id

  attr_accessible :project_id, :comments_attributes
  accepts_nested_attributes_for :comments

  COST = [0,1,2,3]

  validates :project_id, :presence => true

  scope :unassigned, lambda{ parent.is_a? Project}

  def to_s
    title
  end

  def parent
    get_last(:parent) || project
  end

  def belongs_to_feature?
    get_last(:belongs_to_feature?)
  end

  def belongs_to_sprint?
    get_last(:belongs_to_sprint?)
  end

  def assigned?
    get_last(:assigned?)
  end

  def title
    get_current(:title)
  end

  def body
    get_current(:body)
  end

  def sprint
    get_last(:sprint)
  end

  def feature
    get_last(:feature)
  end

  def user
    get_last(:user)
  end

  def status
    get_last(:status)
  end

  def cost
    get_last(:cost)
  end

  private
  def get_current(attr)
    attr = attr.to_sym
    comments.collect(&attr).compact.last
  end
  def get_last(attr)
    comments.last.try(attr)
  end
end

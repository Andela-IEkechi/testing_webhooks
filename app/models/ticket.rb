class Ticket < ActiveRecord::Base
  before_create :populate_scoped_id

  belongs_to :project #always
  has_many :comments, :order => :id

  belongs_to :last_comment, :class_name => 'Comment'
  has_one :assignee, :through => :last_comment
  has_one :feature,  :through => :last_comment
  has_one :sprint,   :through => :last_comment
  has_one :status,   :through => :last_comment

  attr_accessible :project_id, :comments_attributes, :title
  accepts_nested_attributes_for :comments

  COST = [0,1,2,3]

  validates :project_id, :presence => true
  validates :title, :length => {:minimum => 3}

  scope :unassigned, lambda{ parent.is_a? Project}

  scope :for_assignee_id, lambda{ |assignee_id| { :conditions => ['comments.assignee_id = ?', assignee_id], :joins => :last_comment}}
  scope :for_sprint_id, lambda{|sprint_id| { :conditions => ['comments.sprint_id = ?', sprint_id], :joins => :last_comment}}
  scope :for_feature_id, lambda{|feature_id| { :conditions => ['comments.feature_id = ?', feature_id], :joins => :last_comment}}
  scope :search_by_partial_id, lambda{|s| {:conditions => ["CAST(tickets.scoped_id as text) LIKE :search", {:search => "%#{s.to_s.downcase}%"} ]}}

  def to_s
    title
  end

  def parent
    get_last(:parent) || project
  end

  def body
    get_last(:body)
  end

  def user
    #the user is the guy who logged the ticket, ie, the owner of the first comment on the ticket.
    get_first(:user)
  end

  def user_id
    user.id rescue nil
  end

  def cost
    get_last(:cost)
  end

  def assignees
    comments.collect(&:assignee).compact.uniq
  end

  def filter_summary
    [id, title, feature && feature.title, sprint && sprint.goal, status].join("").downcase
  end

  def open?
    get_last(:status).open
  end

  def closed?
    !open?
  end

  def sprint_id
    sprint && sprint.id || nil
  end

  def feature_id
    feature && feature.id || nil
  end

  def update_last_comment!
    self.last_comment = self.comments.last
    self.save!
  end

  def to_param
    self.scoped_id
  end

  private

  #this returns the values as set in the last comment
  def get_first(attr)
    comments.first.try(attr)
  end

  def get_last(attr)
    comments.last.try(attr)
  end

  def populate_scoped_id
    project.increment!(:tickets_sequence)
    self[:scoped_id] = project.tickets_sequence
  end


end

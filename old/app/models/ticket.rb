class Ticket < ActiveRecord::Base
  include Scoped

  belongs_to :project #always
  has_many :comments, :order => :id, dependent: :destroy
  has_many :assets, :through => :comments
  has_many :split_tickets, :order => 'tickets.id ASC', :through => :comments

  belongs_to :last_comment, :class_name => 'Comment'
  belongs_to :source_comment, :class_name => 'Comment'
  has_one :assignee, :through => :last_comment
  has_one :sprint,   :through => :last_comment
  has_one :status,   :through => :last_comment

  attr_accessible :project_id, :comments_attributes, :title, :source_comment_id
  accepts_nested_attributes_for :comments

  COST = [0,1,2,3]

  validates :project_id, :presence => true
  validates :title, :length => {:minimum => 3}

  scope :unassigned, lambda{ parent.is_a? Project}

  scope :for_assignee_id, lambda{ |assignee_id| { :conditions => ['comments.assignee_id = ?', assignee_id], :joins => :last_comment, :include => :status}}
  scope :for_sprint_id, lambda{|sprint_id| { :conditions => ['comments.sprint_id = ?', sprint_id], :joins => :last_comment, :include => :status}}

  sifter :search do |string|
    scoped_id.eq(string.to_i) | title.matches("%#{string}%")
  end

  delegate :cost, :to => :last_comment, :prefix => false, :allow_nil => true
  delegate :tag_list, :to => :last_comment, :prefix => false, :allow_nil => true

  def to_s
    title
  end

  def parent
    return last_comment.parent if last_comment
    project
  end

  def body
    last_comment.body
  end

  def user
    #the user is the guy who logged the ticket, ie, the owner of the first comment on the ticket.
    comments.first.user
  end

  def user_id
    user.id rescue nil
  end

  def sprint_id
    (last_comment.sprint.id rescue nil)
  end

  def assignees
    @assignees ||= comments.collect(&:assignee).compact.uniq
  end

  def filter_summary
    [id, title, sprint && sprint.goal, status].join("").downcase
  end

  def open?
    @open ||= last_comment.status.open
  rescue
    true
  end

  def closed?
    !open?
  end

  def update_last_comment!
    self.update_attribute(:last_comment_id, (Comment.where(:ticket_id => self.id).last.id rescue nil))
  end

end

class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  before_create :owner_membership
  after_create :default_statuses

  belongs_to :user
  has_many :features, :dependent => :destroy, :order => :scoped_id
  has_many :tickets, :dependent => :destroy, :include => :comments, :order => "tickets.id"
  has_many :sprints, :dependent => :destroy, :order => :scoped_id
  has_many :ticket_statuses, :dependent => :destroy

  has_many :memberships, :dependent => :destroy, :include => :user
  has_many :api_keys, :dependent => :destroy

  attr_accessible :title, :private, :user_id, :ticket_statuses_attributes, :api_keys_attributes, :memberships_attributes, :membership_ids, :description
  accepts_nested_attributes_for :ticket_statuses, :memberships
  accepts_nested_attributes_for :api_keys, :allow_destroy => true

  validates :title, :presence => true, :uniqueness => {:scope => :user_id}

  attr :remove_me

  default_scope order('projects.title ASC')

  scope :opensource, where(:private => false)

  def to_param
    self.slug
  end

  def to_s
    title
  end

  def public?
    !private
  end

  private
  def default_statuses
    #when we create a new project, we make sure we create at least two statuses for the tickets in the project
    self.ticket_statuses.create(:name => 'new')
    self.ticket_statuses.create(:name => 'closed', :open => false)
  end

  def owner_membership
    self.memberships.build(:user_id => self.user_id, :role => 'admin')
  end
end

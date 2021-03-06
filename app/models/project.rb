class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  before_create :owner_membership
  after_create :default_statuses

  belongs_to :user
  has_many :tickets, :dependent => :destroy, :include => :comments
  has_many :comments, :through => :tickets
  has_many :sprints, :dependent => :destroy, :order => :scoped_id
  has_many :assets, :dependent => :destroy, :order => :scoped_id
  has_many :ticket_statuses, :dependent => :destroy, :order => 'ticket_statuses.sort_index asc'

  has_many :memberships, :dependent => :destroy, :include => :user, :order => 'users.email asc'
  has_many :users, :through => :memberships
  has_many :api_keys, :dependent => :destroy

  mount_uploader  :logo, LogoUploader
  attr_accessible :logo

  attr_accessible :title, :private, :user_id, :ticket_statuses_attributes, :api_keys_attributes, :memberships_attributes, :membership_ids, :description
  accepts_nested_attributes_for :ticket_statuses, :memberships
  accepts_nested_attributes_for :api_keys

  validates :title, :presence => true
  validates :user, :presence => true

  attr :remove_me

  default_scope order('projects.title ASC')

  scope :opensource, where(:private => false)
  scope :closedsource, where(:private => true)

  def to_param
    self.slug
  end

  def to_s
    title
  end

  def public?
    !private
  end

  def blocked?
    self.user.present? && self.user.account.blocked
  end

  private
  def default_statuses
    #when we create a new project, we make sure we create at least two statuses for the tickets in the project
    self.ticket_statuses.create(:name => 'new', :system_default => true)
    self.ticket_statuses.create(:name => 'closed', :open => false, :system_default => true)
  end

  def owner_membership
    self.memberships.build(:user_id => self.user_id, :role => 'admin')
  end
end

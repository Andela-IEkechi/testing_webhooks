class Project < ActiveRecord::Base
  before_create :owner_participation
  after_create :default_statuses

  belongs_to :user
  has_many :features, :dependent => :destroy, :order => :scoped_id
  has_many :tickets, :dependent => :destroy, :include => :comments, :order => :id
  has_many :sprints, :order => :due_on, :dependent => :destroy, :order => :scoped_id
  has_many :ticket_statuses, :dependent => :destroy

  has_many :memberships # works
  has_many :participants, :through => :memberships, :source => :user, :order => 'email asc'
  has_many :api_keys, :dependent => :destroy

  attr_accessible :title, :private, :ticket_statuses_attributes, :user_id, :participant_ids, :participants_attributes, :api_keys_attributes, :api_key_ids, :memberships
  accepts_nested_attributes_for :ticket_statuses, :participants, :memberships
  accepts_nested_attributes_for :api_keys, :allow_destroy => true

  validates :title, :presence => true, :uniqueness => {:scope => :user_id}

  default_scope order('projects.title ASC')

  def to_s
    title
  end

  def ordered_participants
    self.participants.order(:email)
  end

  def members_but_owner
    self.memberships.reject{|m| m.user_id == self.user.id}
  end

  private
  def default_statuses
    #when we create a new project, we make sure we create at least two statuses for the tickets in the project
    self.ticket_statuses.create(:name => 'new')
    self.ticket_statuses.create(:name => 'closed', :open => false)
  end

  def owner_participation
    self.participants << self.user
  end

end

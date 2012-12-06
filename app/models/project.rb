class Project < ActiveRecord::Base
  before_create :set_api_key
  before_create :owner_participation
  after_create :default_statuses

  belongs_to :user
  has_many :features, :dependent => :destroy
  has_many :tickets, :dependent => :destroy
  has_many :sprints, :order => :due_on, :dependent => :destroy
  has_many :ticket_statuses, :dependent => :destroy
  # has_and_belongs_to_many :participants, :association_foreign_key => 'user_id', :class_name => 'User', :order => 'email asc'

  has_many :memberships # works
  has_many :participants, :through => :memberships, :source => :user, :order => 'email asc'

  # attr_accessible :title, :ticket_statuses_attributes, :user_id, :sprint_duration, :api_key, :participant_ids, :participants_attributes
  # accepts_nested_attributes_for :ticket_statuses, :participants
  attr_accessible :title, :ticket_statuses_attributes, :user_id, :sprint_duration, :api_key
  accepts_nested_attributes_for :ticket_statuses

  validates :title, :presence => true, :uniqueness => {:scope => :user_id}
  validates :api_key, :presence => true, :on => :update

  def to_s
    title
  end

  def ordered_participants
    self.participants.order(:email)
  end


  private
  def default_statuses
    #when we create a new project, we make sure we create at least two statuses for the tickets in the project
    self.ticket_statuses.create(:name => 'new')
    self.ticket_statuses.create(:name => 'closed', :open => false)
  end

  def set_api_key
    require 'digest/sha1'
    self.api_key = Digest::SHA1.hexdigest Time.now.to_s
  end

  def owner_participation
    self.participants << self.user
  end

end

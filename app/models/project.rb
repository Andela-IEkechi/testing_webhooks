class Project < ActiveRecord::Base
  after_create :default_statuses

  belongs_to :user
  has_many :features, :dependent => :destroy
  has_many :tickets, :dependent => :destroy
  has_many :sprints, :order => :due_on, :dependent => :destroy
  has_many :ticket_statuses, :dependent => :destroy
  has_and_belongs_to_many :users

  attr_accessible :title, :ticket_statuses_attributes, :user_id
  accepts_nested_attributes_for :ticket_statuses

  validates :title, :presence => true, :uniqueness => {:scope => :user_id}

  def to_s
    title
  end

  private
  def default_statuses
    #when we create a new project, we make sure we create at least two statuses for the tickets in the project
    self.ticket_statuses.create(:name => 'new')
    self.ticket_statuses.create(:name => 'closed')
  end
end

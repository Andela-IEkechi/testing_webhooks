class Project < ActiveRecord::Base
  after_create :default_statuses

  has_many :features
  has_many :tickets
  has_many :sprints, :order => :due_on

  has_many :ticket_statuses

  attr_accessible :title, :ticket_statuses_attributes
  accepts_nested_attributes_for :ticket_statuses

  validates :title, :presence => true, :uniqueness => true #must be unique for the project owner

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

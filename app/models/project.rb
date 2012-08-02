class Project < ActiveRecord::Base
  after_create :default_statuses

  has_many :features
  has_many :tickets, :as => :ticketable
  has_many :ticket_statuses

  attr_accessible :title, :ticket_statuses_attributes
  accepts_nested_attributes_for :ticket_statuses

  validates :title, :presence => true

  def to_s
    title
  end

  def project
    self
  end

  private
  def default_statuses
    #when we create a new project, we make sure we create at least two statuses for the tickets in the project
    self.ticket_statuses.create(:name => 'new')
    self.ticket_statuses.create(:name => 'closed')
  end
end

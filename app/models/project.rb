class Project < ActiveRecord::Base
  has_many :features
  has_many :tickets, :as => :ticketable

  attr_accessible :title

  validates :title, :presence => true

  def to_s
    title
  end
end

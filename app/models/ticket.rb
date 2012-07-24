class Ticket < ActiveRecord::Base
	belongs_to :feature

  attr_accessible :title, :body

  validates :title, :presence => true
end

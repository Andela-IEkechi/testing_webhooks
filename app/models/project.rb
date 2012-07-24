class Project < ActiveRecord::Base
  has_many :features

  attr_accessible :title

  validates :title, :presence => true
end

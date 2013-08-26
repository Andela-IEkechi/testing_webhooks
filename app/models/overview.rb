class Overview < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :projects

  attr_accessor :project_all
  attr_accessible :title, :filter, :project_ids, :project_all

  validates :title, :length => {:minimum => 3, :maximum => 20}, :uniqueness => {:scope => :user_id}
  validates :filter, :presence => true
  validates :user_id, :presence => true

  def any_project?
    !projects.any? #true if we dont have any specific projects
  end

  def to_s
    title
  end

end

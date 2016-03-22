class Status < ActiveRecord::Base
  belongs_to :project
  has_many :comments, :foreign_key => 'status_id'

  before_destroy :check_for_comments

  attr_accessible :name, :open, :sort_index, :system_default #cant use "type"

  validates :name, :presence => true, :uniqueness => {:scope => :project_id}
  validates :project, :presence => true

  default_scope :order => "sort_index ASC"

  sifter :search do |string|
    name.matches("%#{string}%")
  end

  def to_s
    name
  end

  def close!
    self.open = false
    self.save!
  end

  def open!
    self.open = true
    self.save!
  end

  private

  def check_for_comments
    if comments && comments.count > 0
      errors.add(:base, "cannot delete a ticket status while comments refer to it")
      return false
    end
    return true
  end
end

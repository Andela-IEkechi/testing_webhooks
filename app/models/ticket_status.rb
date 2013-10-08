class TicketStatus < ActiveRecord::Base
  default_scope :order => "sort_index asc"
  belongs_to :project
  has_many :comments, :foreign_key => 'status_id'

  before_destroy :check_for_comments
  before_destroy :check_prevent_deleting_system_default

  attr_accessible :name, :open, :sort_index, :system_default #cant use "type"

  validates :name, :presence => true, :uniqueness => {:scope => :project_id}
  validates :project_id, :presence => true

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

  def check_prevent_deleting_system_default
    if system_default?
      errors.add(:base, "cannot delete a ticket status if it is project's default")
      return false
     end
     return true
  end

  def check_for_comments
    if comments && comments.count > 0
      errors.add(:base, "cannot delete a ticket status while comments refer to it")
      return false
    end
    return true
  end
end

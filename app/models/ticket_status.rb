# == Schema Information
#
# Table name: ticket_statuses
#
#  id             :integer          not null, primary key
#  project_id     :integer          not null
#  name           :string(255)      not null
#  open           :boolean          default(TRUE)
#  sort_index     :integer
#  system_default :boolean
#

class TicketStatus < ActiveRecord::Base
  default_scope :order => "sort_index asc"
  belongs_to :project
  has_many :comments, :foreign_key => 'status_id'

  before_destroy :check_for_comments
  before_destroy :check_prevent_deleting_system_default

  attr_accessible :name, :open, :sort_index #cant use "type"

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

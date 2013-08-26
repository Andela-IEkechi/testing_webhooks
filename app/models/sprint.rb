# == Schema Information
#
# Table name: sprints
#
#  id         :integer          not null, primary key
#  due_on     :date             not null
#  goal       :string(255)      not null
#  project_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  scoped_id  :integer          default(0)
#

class Sprint < ActiveRecord::Base
  include TicketHolder
  include Scoped

  belongs_to :project #not optional

  attr_accessible :goal, :due_on

  validates :project_id, :presence => true
  validates :goal, :presence => true, :uniqueness => {:scope => :project_id}
  validates :due_on, :presence => true

  def to_s
    goal
  end

  def running?
    Date.today <= due_on.to_date
  end

  def open?
    running? || has_open_tickets?
  end

  def closed?
    !open?
  end

end

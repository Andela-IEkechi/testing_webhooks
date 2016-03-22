class Sprint < ActiveRecord::Base
  include TicketHolder
  include Scoped

  belongs_to :project #not optional
  has_many   :assets, dependent: :destroy

  attr_accessible :goal, :due_on, :notify_while_open

  validates :project, :presence => true
  validates :goal, :presence => true, :uniqueness => {:scope => :project_id}
  validates :due_on, :presence => true

  default_scope :order => "goal ASC"
  scope :notification_enabled, where(:notify_while_open => true)

  sifter :search do |string|
    scoped_id.eq(string.to_i) | goal.matches("%#{string}%")
  end

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

  def participants
    users = assigned_tickets.collect(&:assignees).flatten.compact.uniq

    #select only users who are members of the project (they might have been take off since they last commented)
    users.select{|user| user.memberships.to_project(self.project_id)}
  end

end

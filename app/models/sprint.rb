class Sprint < ActiveRecord::Base
  belongs_to :project

  include TicketHolder

  attr_accessible :title, :due_on

  validates :project_id, :presence => true
  validates :title, :presence => true, :uniqueness => {:scope => :project_id}

  def cost
    tickets.sum(&:cost)
  end

  def to_s
    title
  end

  def assigned_tickets
    tickets.collect do |ticket|
      ticket if ticket.sprint_id == self.id
    end.compact.uniq
  end
end

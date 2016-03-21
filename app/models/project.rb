class Project < ApplicationRecord
  has_many :ticket_statuses
  has_many :memberships
  has_many :boards
  has_many :tickets

  validates :title, presence: true

  # TODO: add a logo
  # TODO: add slugs

  accepts_nested_attributes_for :ticket_statuses, allow_destroy: true
  accepts_nested_attributes_for :memberships, allow_destroy: true

  after_create :ensure_system_statuses

  private

  #create the predefined system statuses for tickets
  def ensure_system_statuses
    TicketStatus::SYSTEM[:open].each do |name|
      ticket_statuses.open.create(name: name, order: ticket_statuses.count)
    end
    TicketStatus::SYSTEM[:closed].each do |name|
      ticket_statuses.closed.create(name: name, order: ticket_statuses.count)
    end
  end

end

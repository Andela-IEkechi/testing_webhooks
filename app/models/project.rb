class Project < ApplicationRecord
  has_many :memberships
  has_many :boards
  has_many :tickets
  has_many :ticket_statuses

  validates :title, presence: true, uniqueness: true
  # TODO: add a logo
end

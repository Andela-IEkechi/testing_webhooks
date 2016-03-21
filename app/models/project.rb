class Project < ApplicationRecord
  has_many :memberships
  has_many :boards
  has_many :tickets
  has_many :ticket_statuses

  validates :title, presence: true

  # TODO: add a logo
  # TODO: add slugs


end

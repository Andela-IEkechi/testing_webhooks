class Board < ApplicationRecord
  belongs_to :project
  has_many :tickets

  validates :name, presence: true, uniqueness: {scope: :project_id}

  # TODO: a board should be able to hold assets, same as a comment and a project
end

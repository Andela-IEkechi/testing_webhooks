class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :board, optional: true

  has_many :comments

  # TODO: delegate cost, status etc to :last_comment
end

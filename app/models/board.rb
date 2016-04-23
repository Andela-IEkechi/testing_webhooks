class Board < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :tickets

  validates :name, presence: true, uniqueness: {scope: :project_id}
end

class Board < ApplicationRecord
  belongs_to :project
  has_many :tickets

  validates :name, presence: true, uniqueness: {scope: :project_id}
end

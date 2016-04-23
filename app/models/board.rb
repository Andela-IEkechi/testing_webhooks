class Board < ApplicationRecord
  belongs_to :project

  validate :name, presence: true, uniqueness: {scope: :project_id}
end

class Status < ApplicationRecord
  acts_as_list scope: [:position]

  belongs_to :project

  validates :name, presence: true, uniqueness: {scope: :project_id}
end

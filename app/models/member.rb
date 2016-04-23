class Member < ApplicationRecord
  belongs_to :project
  belongs_to :user

  ROLES=%w(restricted regular administrator owner)

  validates :role, presence: true, inclusion: {in: ROLES}
end

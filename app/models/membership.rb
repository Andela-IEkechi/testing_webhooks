class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :project

  ROLES=['guest', 'restricted', 'regular', 'administrator', 'owner']
  validates :role, presence: true, inclusion: {in: ROLES}
end

class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :project

  ROLES=['guest', 'restricted', 'regular', 'administrator', 'owner']
  validates :role, presence: true, inclusion: {in: ROLES}

  ROLES.each do |r|
    scope r.to_sym, ->{where(:role => r)}
  end
end

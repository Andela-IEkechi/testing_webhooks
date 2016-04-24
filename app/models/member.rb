class Member < ApplicationRecord
  belongs_to :project
  belongs_to :user

  ROLES=%w(restricted regular administrator owner)

  validates :role, presence: true, inclusion: {in: ROLES}

  ROLES.each do |role_name|
    scope role_name.pluralize.to_sym, ->{where(role: role_name)}
  end

  scope :unrestricted, ->{where.not(role: "restricted")}
end

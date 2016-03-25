class Member < ApplicationRecord
  belongs_to :user
  belongs_to :project

  ROLES=['guest', 'restricted', 'regular', 'administrator', 'owner']
  validates :role, presence: true, inclusion: {in: ROLES}

  #make sure we only have one membership per user per project
  validates :user_id, uniqueness: {scope: :project_id}

  #simplify forms
  delegate :email, :to => :user, :prefix => false, :allow_nil => true
  validates :email, format: {with: Devise::email_regexp}

  ROLES.each do |r|
    scope r.to_sym, ->{where(:role => r)}
  end

end

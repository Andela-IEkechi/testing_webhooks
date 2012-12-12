class Membership < ActiveRecord::Base

  ROLE_NAMES = %w(Owner Admin Regular Restricted)

  attr_accessible :role

  belongs_to :user
  belongs_to :project

  validates_inclusion_of :role, :in => ROLE_NAMES

  def admin?
    self.role == 'Admin'
  end

  def regular_user?
    self.role == 'Regular'
  end

end

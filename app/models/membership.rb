class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  ROLE_NAMES = %w(admin regular restricted)

  validates_inclusion_of :role, :in => ROLE_NAMES

  attr_accessible :role, :user_id, :project_id

  def admin?
    self.role == 'admin'
  end

  def regular_user?
    self.role == 'regular'
  end

  def restricted_user?
    self.role == 'restricted'
  end

end

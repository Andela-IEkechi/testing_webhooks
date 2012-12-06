class Membership < ActiveRecord::Base
  #attr_accessible :is_admin

  belongs_to :user
  belongs_to :project

  def admin?
    is_admin
  end

  def regular_user?
    !is_admin
  end

end

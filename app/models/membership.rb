class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  ROLE_NAMES = %w(admin regular restricted)

  validates :role, :inclusion => {:in => ROLE_NAMES}
  validates :user_id, :presence => true
  validates :project_id, :presence => true

  scope :for_user, lambda{|user_id| {:conditions => {:user_id => user_id}}}
  scope :by_email, lambda{|email| {:conditions => ['LOWER(users.email) = LOWER(?)', email], :joins => :user}}
  scope :admins, where(:role => 'admin')

  attr_accessible :role, :user_id, :project_id

  delegate :email, :to => :user, :prefix => false, :allow_nil => true

  def admin?
    self.role == 'admin'
  end

  def regular?
    self.role == 'regular'
  end

  def restricted?
    self.role == 'restricted'
  end

  def admin!
    unless self.admin?
      self.role = 'admin'
      self.save
    end
  end

end

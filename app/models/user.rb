class User < ActiveRecord::Base
  has_one :account
  has_many :projects, :dependent => :destroy #projects we own
  has_many :tickets, :through => :projects #tickets we are assigned to
  has_many :memberships, :include => :project, :dependent => :destroy

  after_create :create_account

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,:token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :provider, :uid, :full_name,
                  :terms, :chosen_plan, :preferences

  validates :terms, acceptance: {accept: true}

  scope :active, where("deleted_at IS NULL")
  scope :deleted, where("deleted_at IS NOT NULL")

  serialize :preferences

  after_initialize do |user|
    user.preferences ||= {}
    user.preferences = OpenStruct.new(user.preferences)
  end

  def to_s
    if confirmed?
      email
    else
      "#{email} (invited)"
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_or_create_for_github_oauth(auth, signed_in_resource=nil)
    unless user = User.where(:provider => auth.provider, :uid => auth.uid).first
      if user = User.find_by_email(auth.info.email)
        #user.name ||= auth.extra.raw_info.name
        user.provider ||= auth.provider
        user.uid ||= auth.uid
        user.save
      else
        user = User.create(#name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                           )
      end
    end
    user
  end

  # con 782
  def soft_delete
    # First check the user's own projects:
    # - if the project didn't have other users, delete it
    self.projects.select{|p| p.memberships.size == 1}.each do |p|
      p.memberships.first.delete
      p.delete
    end

    # - if there are other admins, the project stays the same
    # - if there are no other admins, all remaining are upgraded to admin
    self.projects.each do |p|
      # if only one user is and admin of the project, it's the owner
      if (p.memberships.select{|m| m.role == 'admin'}.size == 1)
        p.memberships.each{|m| m.update_attribute(:role, "admin")}
      end
    end

    self.memberships.each{|m| m.delete} # remove any other memberships
    update_attribute(:deleted_at, Time.current) # finally, set deletion timestamp

  end

  def active?
    !deleted_at
  end

  def deleted?
    !!deleted_at
  end

  # Prevent "soft deleted" users from signing in
  # http://stackoverflow.com/a/8107966/483566
  def active_for_authentication?
    super && !deleted_at
  end

end

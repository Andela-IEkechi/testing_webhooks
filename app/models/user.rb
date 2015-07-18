class User < ActiveRecord::Base
  acts_as_token_authenticatable

  has_one :account, :dependent => :destroy
  has_many :projects, :dependent => :destroy #projects we own
  has_many :tickets, :through => :projects #tickets we are assigned to
  has_many :memberships, :include => :project, :dependent => :destroy
  has_many :overviews, :dependent => :destroy

  after_create :create_account, :unless => lambda{|u| u.account}

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :provider, :uid, :full_name,
                  :terms, :chosen_plan, :preferences,
                  :github_login

  validates :terms, acceptance: {accept: true}

  # scope :active, where("deleted_at IS NULL")
  # scope :deleted, where("deleted_at IS NOT NULL")

  serialize :preferences

  after_initialize do |user|
    user.preferences ||= {}
    user.preferences = OpenStruct.new(user.preferences) unless user.preferences.class == OpenStruct #dont do it twice
    user.preferences.page_size ||= 10 #default it to something sane
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
Rails.logger.info auth
    unless user = User.where(:provider => auth.provider, :uid => auth.uid).first
      # user not found with provider and uid, try to find by email from provider.
      if user = User.find_by_email(auth.info.email)
        user.provider ||= auth.provider
        user.uid ||= auth.uid
        user.github_login ||= auth.info.login if auth.provider == 'github'
        user.save
      elsif (auth.provider == 'github') && (user = User.find_by_github_login(auth.info.login))
        # user not found by email, try to find with github_login if provider is github.
        user.provider ||= auth.provider
        user.uid ||= auth.uid
        user.email ||= auth.info.email # set conductor email same as github_email if not set already .
        user.save
      else
        # this looks like a first time login with github or other provider. create a new user with information from passed information.
        user_params = { provider:auth.provider, uid:auth.uid, email:auth.info.email, password:Devise.friendly_token[0,20] }
        user_params.merge!(github_login:auth.info.login) if auth.provider == 'github'
        user = User.create(user_params)
      end
    end
    user
  end

  def soft_delete
    #we dont allow users to delete themselves if they have open projects
    return if self.projects.select{|p| p.memberships.count > 1}.compact.size > 0

    #remove any memberships to projects we don't own
    self.memberships.each do |m|
      unless m.project.user_id == self.id
        m.destroy
      end
    end

    #delete all our own projects
    self.projects.find_each(&:destroy)

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
    super && self.active?
  end

  def obfuscated
    obfuscated_email = email.gsub(/(.+@).+/,'\1...')
    if !confirmed?
      return "#{obfuscated_email} (invited)"
    end
    obfuscated_email
  end

  #NOTE: this needs to move to a concern when we upgrade to rails 4
  #previous version of devise had this built in. We now use the simple_token_authentication gem, which does not provide it.
  #AR also publishes reset_* methods per attribute, so we rather use "regenerate" here
  def regenerate_authentication_token!
    self.update_attribute(:authentication_token, generate_authentication_token(token_generator))
  end
end

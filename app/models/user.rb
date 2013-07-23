# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  authentication_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#  full_name              :string(255)
#  terms                  :boolean          default(FALSE)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  preferences            :text
#  deleted_at             :datetime
#

class User < ActiveRecord::Base
  has_one :account, :dependent => :destroy
  has_many :projects, :dependent => :destroy #projects we own
  has_many :tickets, :through => :projects #tickets we are assigned to
  has_many :memberships, :include => :project, :dependent => :destroy
  has_many :overviews, :dependent => :destroy

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

end

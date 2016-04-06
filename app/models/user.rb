class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :lockable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  devise :omniauthable, :omniauth_providers => [:facebook, :github, :google_oauth2, :bitbucket]

  has_one :account, dependent: :destroy
  has_many :memberships, class_name: "Member", dependent: :destroy
  has_many :projects, through: :memberships
  has_many :overviews, dependent: :destroy
  has_many :integrations, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  accepts_nested_attributes_for :integrations

  def to_s
    full_name || email
  end

  serialize :preferences
  
  attr :project_tab
  attr :ticket_order
  attr :page_size
end


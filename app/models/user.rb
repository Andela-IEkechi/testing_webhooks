class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :lockable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  devise :omniauthable, :omniauth_providers => [:facebook, :github, :google_oauth2]

  has_one :account, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships
  has_many :overviews, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end


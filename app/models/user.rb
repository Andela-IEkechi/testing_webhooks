class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :lockable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  devise :omniauthable, :omniauth_providers => [:facebook, :github, :google_oauth2]

  has_many :memberships
  has_many :projects, through: :memberships
  has_many :overviews

  validates :email, presence: true, uniqueness: true
end


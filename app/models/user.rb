class User < ApplicationRecord
  after_create :create_account
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  has_one :account, dependent: :destroy
  has_and_belongs_to_many :memberships, dependent: :destroy, class_name: "Member"

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  serialize :preferences, Hash
end

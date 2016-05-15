class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  attachment :logo
  
  has_many :members, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_and_belongs_to_many :memberships, dependent: :destroy, class_name: "Member"

  validates :name, presence: true

end

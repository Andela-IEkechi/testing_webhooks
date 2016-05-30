class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  attachment :logo
  
  has_many :members, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :api_keys, dependent: :destroy
  has_and_belongs_to_many :memberships, dependent: :destroy, class_name: "Member"

  validates :name, presence: true

  accepts_nested_attributes_for :api_keys

end

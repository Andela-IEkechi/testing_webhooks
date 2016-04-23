class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  attachment :logo_id
  
  has_many :members, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :boards, dependent: :destroy

  validate :name, presence: true
end

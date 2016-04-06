class Integration < ApplicationRecord
  belongs_to :user

  before_save :generate_key

  PARTIES=[:github, :bitbucket, :chrome]

  validates :party, presence: true, inclusion: {in: PARTIES}
  validates :enabled, presence: true, inclusion: {in: [true, false]}
  validates :key, presence: true, uniqueness: true

  scope :enabled,  ->{where(enabled: true)}
  scope :disabled, ->{where(open: false)}

  def generate_key
    key = Devise.friendly_token

    while Integration.where(:key => key).any? do
      key = Devise.friendly_token
    end
  end
end

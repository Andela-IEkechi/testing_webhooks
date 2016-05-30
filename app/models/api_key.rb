class ApiKey < ApplicationRecord
  belongs_to :project
  before_create :generate_access_key

  validates :name, uniqueness: { scope: :project_id }, length: { minimum: 5 }
  validates :access_key, uniqueness: true, on: :create
  validates :project_id, presence: true


  def generate_access_key
    unless self.access_key
      self.access_key = Devise.friendly_token
    end
  end
end

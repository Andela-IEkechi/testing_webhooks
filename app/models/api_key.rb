class ApiKey < ActiveRecord::Base
  before_save :generate_token
  belongs_to :project

  validates :name, :uniqueness => {:scope => :project_id}, :length => {:minimum => 5}
  validates :token, :presence => true, :uniqueness => true
  validates :project_id, :presence => true

  attr_accessible :project_id, :token, :name

  private
  def generate_token
    self.token = Devise.friendly_token.first(32)

    while ApiKey.find_by_token(self.token) do
      self.token = Devise.friendly_token.first(32)
    end
  end
end

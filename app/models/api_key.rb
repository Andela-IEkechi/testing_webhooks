class ApiKey < ActiveRecord::Base
  self.primary_key = 'name'

  before_create :generate_token
  belongs_to :project

  validates :name, :uniqueness => {:scope => :project_id}, :length => {:minimum => 5}
  validates :token, :uniqueness => true, :on => :create
  validates :project_id, :presence => true

  attr_accessible :project_id, :token, :name


  def generate_token
    self.token = Devise.friendly_token

    while ApiKey.find_by_token(self.token) do
      self.token = Devise.friendly_token
    end
  end
end

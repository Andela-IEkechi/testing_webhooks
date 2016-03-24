class Project < ApplicationRecord
  has_many :statuses, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates :title, presence: true

  # TODO: add a logo
  # TODO: add slugs

  accepts_nested_attributes_for :statuses, allow_destroy: true
  accepts_nested_attributes_for :memberships, allow_destroy: true

  after_create :ensure_system_statuses

  def has_member(user)
    return false unless user.is_a?(User)
    memberships.where(user_id: user.id).any?
  end

  private

  #create the predefined system statuses for tickets
  def ensure_system_statuses
    Status::SYSTEM[:open].each do |name|
      statuses.open.create(name: name, order: statuses.count)
    end
    Status::SYSTEM[:closed].each do |name|
      statuses.closed.create(name: name, order: statuses.count)
    end
  end

end

class Project < ApplicationRecord
  has_paper_trail

  has_many :statuses, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy

  validates :name, presence: true, length: {minimum: 3}

  # TODO: add a logo
  # TODO: add slugs

  accepts_nested_attributes_for :statuses, allow_destroy: true
  accepts_nested_attributes_for :members, allow_destroy: true

  accepts_nested_attributes_for :documents, allow_destroy: true

  after_create :ensure_system_statuses

  attr :files #used for file uploads
  mount_uploader :logo, LogoUploader

  def has_member?(user)
    return false unless user.is_a?(User)
    members.where(user_id: user.id).any?
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

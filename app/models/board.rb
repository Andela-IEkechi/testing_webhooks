class Board < ApplicationRecord
  has_paper_trail

  belongs_to :project
  has_many :statuses, through: :project
  has_many :comments #we assign tickets to boards via comments
  has_many :tickets, -> { distinct }, through: :comments  #dont destroy tickets if the board gets deleted, they just go back in the pool
  has_many :assets, as: :assetable, dependent: :destroy

  validates :name, presence: true, uniqueness: {scope: :project_id}, length: {minimum: 3}
end

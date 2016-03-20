class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  has_many :assets, as: :assetable

  # TODO: add attachments, status, cost, user,
end

class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  has_many :assets, as: :assetable, dependent: :destroy

  # has_many   :split_tickets, :order => 'tickets.id ASC', :class_name => "Ticket", :foreign_key => "source_comment_id"
  # has_many   :assets, dependent: :destroy

  belongs_to :assignee, class_name: 'User', optional: true # the user the ticket is assigned to
  belongs_to :status

  # TODO: add attachments, status, cost, user,
end

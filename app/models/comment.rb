class Comment < ApplicationRecord
  acts_as_taggable

  belongs_to :ticket
  belongs_to :commenter, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :status

  has_many :attachments, dependent: :destroy
  has_many :split_tickets,  -> { order(id: :asc) }, class_name: "Ticket", foreign_key: "parent_id"

  def previous
    # retrieve the previous comment if there is one
    ticket.comments.where('id < ?', self.id).order(id: :desc).limit(1).first
  rescue
    nil #there might not be a comment
  end

  def to_json(options = {})
    super(include: [:tag_list, previous: { methods: [:tag_list] }])
  end

end

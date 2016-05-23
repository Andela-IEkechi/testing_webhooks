class Comment < ApplicationRecord

  belongs_to :ticket
  has_many :attachments, dependent: :destroy
  belongs_to :commenter, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :status

  def previous
    # retrieve the previous comment if there is one
    ticket.comments.where('id < ?', self.id).order(id: :desc).limit(1).first
  rescue
    nil #there might not be a comment
  end

  def to_json(options = {})
    super(include: :previous)
  end

end

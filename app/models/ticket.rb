class Ticket < ApplicationRecord

  belongs_to :project
  acts_as_sequenced scope: :project_id

  has_many :comments, dependent: :destroy
  has_many :split_tickets, -> { order(id: :asc) }, through: :comments

  has_and_belongs_to_many :boards

  delegate :assignee, :status, to: :last_comment, allow_nil: true

  validates :title, presence: true
  
  # Automatically use the sequential ID in URLs
  def to_param
    self.sequential_id.to_s
  end

  def creator
    comments.first.commenter
  rescue 
    nil #there might be no comment on the ticket
  end

  private

  def last_comment
    comments.last
  end

end

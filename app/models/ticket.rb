class Ticket < ApplicationRecord

  belongs_to :project
  acts_as_sequenced scope: :project_id

  has_many   :comments, dependent: :destroy

  belongs_to :parent, class_name: "Ticket"
  has_many   :children, class_name: "Ticket", as: "parent"

  has_and_belongs_to_many :boards

  delegate :assignee, :status, to: :last_comment, allow_nil: true

  # Automatically use the sequential ID in URLs
  def to_param
    self.sequential_id.to_s
  end

  private

  def last_comment
    comments.last
  end
end

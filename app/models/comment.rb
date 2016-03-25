class Comment < ApplicationRecord
  has_paper_trail
  after_create(:set_last_comment)
  after_destroy(:set_last_comment)

  belongs_to :ticket
  has_many   :documents, as: :documentable, dependent: :destroy
  has_many   :tickets #split tickets

  belongs_to :user, optional: true
  belongs_to :status, optional: true
  belongs_to :board, optional: true
  belongs_to :assignee, class_name: 'User', optional: true # the user the ticket is assigned to

  COSTS = {"unknown": 0, "low": 1, "moderate": 2, "high": 3, "very high": 99 }

  validates :cost, presence: true, inclusion: {in: COSTS.values}

  accepts_nested_attributes_for :documents, allow_destroy: true

  private

  def set_last_comment
    ticket.set_last_comment!
  end
end


# tags
# split tickets
# api hook to attribute to comitter
# should be searchable on text and attachment names

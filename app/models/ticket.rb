class Ticket < ApplicationRecord
  acts_as_sequenced scope: :project_id

  belongs_to :project
  belongs_to :commenter, class_name: "User"
  has_many :comments, dependent: :destroy

end

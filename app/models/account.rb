class Account < ApplicationRecord
  belongs_to :user

  validates :plan, presence: true, inclusion: {in: ['free', 'small', 'medium', 'large']}

  # TODO: deal with plans
end

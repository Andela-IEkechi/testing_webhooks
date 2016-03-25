class Account < ApplicationRecord
  belongs_to :user

  PLANS=['free', 'small', 'medium', 'large']
  validates :plan, presence: true, inclusion: {in: PLANS}

  # TODO: deal with plans
end

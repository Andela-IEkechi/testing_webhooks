class Account < ApplicationRecord
  has_paper_trail
  belongs_to :user

  PLANS=['free', 'small', 'medium', 'large']
  validates :plan, presence: true, inclusion: {in: PLANS}

  # TODO: deal with plans. old code had comparison functions etc
end

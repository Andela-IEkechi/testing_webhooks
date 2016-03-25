FactoryGirl.define do
  factory :comment do
    association(:ticket)
    # association(:user)
    # association(:status)
    # association(:board)
    cost {Comment::COSTS.values.sample}
  end
end

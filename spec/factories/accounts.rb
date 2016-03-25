FactoryGirl.define do
  factory :account do
    association(:user)
    plan {Account::PLANS.sample}
  end
end

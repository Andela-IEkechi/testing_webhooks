FactoryGirl.define do
  factory :status do
    sequence(:name) {|n| "status-#{n}" }
    association(:project)
  end
end

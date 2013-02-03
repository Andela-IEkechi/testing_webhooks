FactoryGirl.define do
  factory :api_key do
    sequence(:name) {|n| "name-#{n}" }
    association(:project)
  end
end

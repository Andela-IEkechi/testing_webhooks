FactoryGirl.define do
  factory :api_key do
    sequence(:name) {|n| "name-#{n}" }
    sequence(:token) {|n| "token-#{n}" }
    association(:project)
  end
end

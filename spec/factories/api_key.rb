FactoryGirl.define do
  factory :api_key do
    sequence(:name) {|n| "name-#{n}" }
    token {Devise.friendly_token}
    association(:project)
  end
end

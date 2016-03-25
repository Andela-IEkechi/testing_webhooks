FactoryGirl.define do
  factory :overview do
    association(:user)
    name {Faker::Lorem.sentence}
  end
end

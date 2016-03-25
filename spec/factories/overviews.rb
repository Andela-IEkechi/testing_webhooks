FactoryGirl.define do
  factory :overview do
    association(:user)
    title {Faker::Lorem.sentence}
  end
end

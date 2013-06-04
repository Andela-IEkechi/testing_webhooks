# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :overview do
    sequence(:title) {|n| "over-#{n}"}
    association :user
    filter {"#{Faker::Lorem.words(1)}:#{Faker::Lorem.words(1)}"}
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email Faker::Lorem.email()

    factory :confirmed_user do
      after(:create) do |user|
        user.confirm!
      end
    end
  end
end

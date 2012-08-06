# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email Faker::Internet.email()

    before(:create) do |user|
      pass = Faker::Lorem.words(6)
      user.password = pass
      user.password_confirmation = pass
    end

    after(:create) do |user|
      user.confirm!
    end
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) {Faker::Internet.email()}
    terms true
    full_name 'Monty'

    before(:create) do |user|
      pass = Faker::Lorem.words(6)
      user.password = pass
      user.password_confirmation = pass
    end

    after(:create) do |user|
      user.confirm!
    end

    factory :unconfirmed_user do
      after(:create) do |user|
        user.confirmed_at = nil
        user.save
      end
    end

    factory :user_with_password do
      password 'goose911'
      password_confirmation 'goose911'
    end
  end
end

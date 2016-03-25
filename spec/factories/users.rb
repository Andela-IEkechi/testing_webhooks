FactoryGirl.define do
  factory :user do
    email {Faker::Internet.email}
    password {Faker::Lorem.words(4).join}
  end
end

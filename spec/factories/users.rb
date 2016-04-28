FactoryGirl.define do
  factory :user, aliases: [:commenter] do
    email {Faker::Internet.email}    
    name {Faker::Name.name}

    before(:create) do |user|
      pass = Faker::Lorem.words(8)
      user.password = pass
      user.password_confirmation = pass
    end

    after(:create) do |user|
      user.confirm
    end    
  end
end

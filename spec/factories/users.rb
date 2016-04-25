FactoryGirl.define do
  factory :user, aliases: [:commenter] do
    email {Faker::Internet.email}    
    name {Faker::Name.name}
    password {'password'}
  end
end

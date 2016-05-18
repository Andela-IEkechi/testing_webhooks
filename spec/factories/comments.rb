FactoryGirl.define do
  factory :comment do
    ticket  
    commenter
    message { Faker::Lorem.sentence }
  end
end

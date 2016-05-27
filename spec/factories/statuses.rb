FactoryGirl.define do
  factory :status do
    project
    name {Faker::Lorem.words(3).join}    
  end
end

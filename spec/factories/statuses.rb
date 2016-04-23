FactoryGirl.define do
  factory :status do
    project
    name {Faker::Lorem.words(2).join}    
  end
end

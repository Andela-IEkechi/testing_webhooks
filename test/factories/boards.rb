FactoryGirl.define do
  factory :board do
    project
    name {Faker::Lorem.words(3).join}    
  end
end

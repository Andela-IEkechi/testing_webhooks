FactoryGirl.define do
  factory :status do
    association(:project)
    name {Faker::Lorem.words(2).join()}
  end
end

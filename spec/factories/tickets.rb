FactoryGirl.define do
  factory :ticket do
    project
    title {Faker::Lorem.sentence}
  end
end

FactoryGirl.define do
  factory :board do
    association(:project)
    name {Faker::Lorem.words(2).join}
  end
end

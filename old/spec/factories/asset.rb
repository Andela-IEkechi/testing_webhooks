FactoryGirl.define do
  factory :asset do
    association(:project)
    payload nil
  end
end

FactoryGirl.define do
  factory :feature do
    sequence(:title) {|n| "feature-#{n}" }
    association :project

    factory :invalid_feature do
      project nil
    end
  end
end

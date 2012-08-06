FactoryGirl.define do
  factory :project do
    sequence(:title) {|n| "project-#{n}" }
    association(:user) create(:confirmed_user)

    factory :invalid_project do
      title nil
    end
  end
end

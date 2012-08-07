FactoryGirl.define do
  factory :project do
    sequence(:title) {|n| "project-#{n}" }
    association(:user)

    factory :invalid_project do
      title nil
    end

    factory :project_with_tickets do
      after(:create) do |project|
        project.tickets << create(:ticket, :project=>project)
        project.save!
      end
    end
  end
end

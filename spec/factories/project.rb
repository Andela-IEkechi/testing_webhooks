FactoryGirl.define do
  factory :project do
    sequence(:title) {|n| "project-#{n}" }
    association(:user)
    #projects are private by default
    description {Faker::Lorem.sentence}

    factory :invalid_project do
      title nil
    end

    factory :public_project do
      private false
    end

    factory :project_with_tickets do
      after(:create) do |project|
        project.tickets << create(:ticket, :project=>project)
        project.save!
      end
    end

    factory :no_api_project do
      api_key nil
    end
  end
end

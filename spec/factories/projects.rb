FactoryGirl.define do
  factory :project do
    title {Faker::Lorem.sentence}

    factory :project_with_tickets do
      transient do
        tickets_count 5
      end

      after(:create) do |project, evaluator|
        #we need to create at least one status
        status = create(:status, project: project)
        create_list(:ticket, evaluator.tickets_count, project: project)
      end
    end

    factory :project_with_tickets_and_comments do
      transient do
        tickets_count 5
      end

      after(:create) do |project, evaluator|
        #we need to create at least one status
        status = create(:status, project: project)
        create_list(:ticket_with_comments, evaluator.tickets_count, project: project)
      end
    end
  end
end

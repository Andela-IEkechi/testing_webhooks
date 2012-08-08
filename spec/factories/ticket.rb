FactoryGirl.define do
  factory :ticket do
    sequence(:title) {|n| "ticket-#{n}" }
    association(:project)

    after(:build) do |ticket|
      #add a mandatory status, unless it's passed in
      ticket.status = ticket.status || ticket.project.ticket_statuses.first
    end
    before(:create) do |ticket|
      #add a mandatory status, unless it's passed in
      ticket.status = ticket.status || ticket.project.ticket_statuses.first
    end

    factory :ticket_for_feature do
      #make sure the feature belongs to the project
      after(:create) do |ticket|
        ticket.feature = create(:feature, :project => ticket.project)
        ticket.save!
      end
    end

    factory :ticket_for_sprint do
      #make sure the sprint belongs to the project
      after(:create) do |ticket|
        ticket.sprint = create(:sprint, :project => ticket.project)
        ticket.save!
      end
    end

    factory :invalid_ticket do
      title "no" #too short
    end
  end
end

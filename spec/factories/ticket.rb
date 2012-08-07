FactoryGirl.define do
  factory :ticket do
    sequence(:title) {|n| "ticket-#{n}" }
    sequence(:cost)  {|n| n % 3}
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
  end
end

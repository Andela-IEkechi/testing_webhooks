FactoryGirl.define do
  factory :ticket do
    sequence(:title) {|n| "ticket-#{n}" }
    sequence(:cost)  {|n| n % 3}
    association(:project)

    after(:build) do |this|
      #add a mandatory status, unless it's passed in
      this.status = this.status || this.project.ticket_statuses.first
    end
    before(:create) do |this|
      #add a mandatory status, unless it's passed in
      this.status = this.status || this.project.ticket_statuses.first
    end

  end
end

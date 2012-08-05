require 'faker'

FactoryGirl.define do
  factory :comment do
    body Faker::Lorem.paragraph()
    association :ticket

    factory :comment_with_status do
      after(:build) do |this|
        this.status = this.ticket.project.ticket_statuses.first
      end
      after(:create) do |this|
        this.status = this.ticket.project.ticket_statuses.first
        this.save!
      end
    end
  end

end

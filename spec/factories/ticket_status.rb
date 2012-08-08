FactoryGirl.define do
  factory :ticket_status do
    sequence(:name) {|n| "status-#{n}" }
    association(:project)
    type 'open'
  end
end

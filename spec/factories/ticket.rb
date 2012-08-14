FactoryGirl.define do
  factory :ticket do
    sequence(:title) {|n| "ticket-#{n}" }
    association(:project)

    factory :invalid_ticket do
      title "no" #too short
    end
  end
end

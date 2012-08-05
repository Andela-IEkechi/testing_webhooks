FactoryGirl.define do
  factory :ticket do
    sequence(:title) {|n| "ticket-#{n}" }

    factory :invalid_ticket do
      title nil
    end
  end
end

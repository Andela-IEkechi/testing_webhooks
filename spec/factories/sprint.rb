FactoryGirl.define do
  factory :sprint do
    sequence(:name) {|n| "sprint-#{n}" }
    sequence(:due_on) {|n| Date.today + n.days}
    association :project

    factory :invalid_sprint do
      project nil
    end
  end
end

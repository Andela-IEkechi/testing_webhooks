# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    association(:user)
    plan "free"
    enabled true

    factory :account_sml_plan do
      plan "small"
    end

  end
end

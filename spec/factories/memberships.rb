# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    association(:user)
    association(:project)
    role "admin"
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_asset, :class => 'Project::Asset' do
    association :project
    payload nil
  end
end

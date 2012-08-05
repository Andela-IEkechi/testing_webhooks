FactoryGirl.define do
  factory :project do
    sequence(:title) {|n| "project-#{n}" }
  end

  factory :invalid_project do
    #no title
  end
end

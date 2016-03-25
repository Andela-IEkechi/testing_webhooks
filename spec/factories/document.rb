FactoryGirl.define do
  factory :document do
    association(:documentable, factory: :project)
  end
end

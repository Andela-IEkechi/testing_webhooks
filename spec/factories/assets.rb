FactoryGirl.define do
  factory :asset do
    association(:assetable, factory: :project)
  end
end

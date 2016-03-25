FactoryGirl.define do
  factory :member do
    association(:project)
    association(:user)
    role {Member::ROLES.sample}
  end
end

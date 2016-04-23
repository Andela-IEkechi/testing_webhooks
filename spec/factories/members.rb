FactoryGirl.define do
  factory :member do
    project
    user
    role {Member::ROLES.sample}
  end
end

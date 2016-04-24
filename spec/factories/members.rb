FactoryGirl.define do
  factory :member, aliases: [:membership] do
    project
    user
    role {Member::ROLES.sample}

    Member::ROLES.each do |r|
      factory r.to_sym do
        role {r}
      end
    end
  end
end

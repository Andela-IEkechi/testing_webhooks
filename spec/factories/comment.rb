require 'faker'

FactoryGirl.define do
  factory :comment do
    body Faker::Lorem.paragraph()
    association :ticket

    factory :invalid_comment do
      ticket nil
    end
  end

end

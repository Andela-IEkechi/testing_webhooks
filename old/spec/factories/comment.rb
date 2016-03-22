# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    association(:user)
    cost 0

    before(:create) do |comment|
      comment.ticket ||= create(:ticket)
      comment.status ||= create(:status, :project => comment.project)
    end

    factory :comment_with_body do
      body {Faker::Lorem.paragraph()}
    end

    factory :comment_with_sprint do
      association(:sprint)
    end

    factory :comment_by_api_key do
      user nil
      association(:api_key)
    end
  end
end

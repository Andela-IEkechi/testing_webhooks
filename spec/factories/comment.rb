# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    association(:ticket)
    association(:user)
    cost 0

    before(:create) do |comment|
      comment.status = create(:ticket_status, :project => comment.project)
    end

    factory :comment_with_body do
      body {Faker::Lorem.paragraph()}
    end

    factory :comment_with_sprint do
      association(:sprint)
    end

    factory :comment_with_feature do
      association(:feature)
    end

    factory :comment_with_feature_and_sprint do
      association(:feature)
      association(:sprint)
    end

    factory :comment_by_api_key do
      user nil
      association(:api_key)
    end
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    association(:ticket)
    association(:feature)
    association(:sprint)
    cost 0

    before(:create) do |comment|
      comment.status = create(:ticket_status, :project => comment.ticket.project)
      comment.user = create(:user)
    end

    factory :comment_with_body do
      body Faker::Lorem.paragraph()
    end

  end
end

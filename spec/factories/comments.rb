FactoryGirl.define do
  factory :comment do
    ticket  
    commenter
    message { Faker::Lorem.sentence }

    before(:create) do |comment|
      comment.status = create(:status, project: comment.ticket.project)
    end
  end
end

FactoryGirl.define do
  factory :ticket do
    association(:project)
    name {Faker::Lorem.sentence}

    factory :ticket_with_comments do
      transient do
        comments_count 5
      end

      after(:create) do |ticket, evaluator|
        status = create(:status, project: ticket.project)
        board = create(:board, project: ticket.project)
        user = create(:member, project: ticket.project).user #user is magically made
        assignee = ticket.project.members.sample.user #user is magically made
        create_list(:comment, evaluator.comments_count,
          ticket: ticket,
          status: status,
          board: board,
          user: user,
          assignee: assignee)
      end
    end
  end
end

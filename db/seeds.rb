require "faker"
p "cleaning out..."
Document.delete_all
Comment.delete_all
Ticket.delete_all
Board.delete_all
Status.delete_all
Project.delete_all
Account.delete_all
User.delete_all
Member.delete_all

p "creating users@example.com..."
user = User.create(email: "user@example.com", password: "password")
user.skip_confirmation_notification!
user.confirm!

p "creating a project for each role..."
Member::ROLES.each do |role|
  project = Project.create(name: "#{role} project")
  user.memberships.create(project: project, role: role)
end

p "create some additional users..."
# create a few more users
4.times do
  user = User.create(email: Faker::Internet.email, password: "password")
  user.skip_confirmation_notification!
  user.confirm!
end

p "assign new users to projects..."
#assign them to projects
User.where.not(:id => user.id).find_each do |user|
  Project.find_each do |proj|
    proj.members.create(user_id: user.id, role: Member::ROLES.sample)
  end
end

p "create boards on each project..."
#create a few boards for every project
Project.find_each do |proj|
  proj.boards.create(name: Faker::Lorem.word)
  proj.boards.create(name: Faker::Lorem.word)
  proj.boards.create(name: Faker::Lorem.word)
end

p "create some tickets for each board"
#create a few tickets for every board
Board.find_each do |board|
  3.times do
    ticket = Ticket.create(name: Faker::Lorem.sentence(3), project_id: board.project_id)

    # create a few more comments for this ticket
    ticket.comments.create(content: Faker::Lorem::paragraph(),
      status_id: board.project.statuses.sample.id,
      user_id: board.project.members.sample.user_id,
      assignee_id: [board.project.members.sample.user_id, nil].sample,
      cost: [Comment::COSTS.values.sample, nil].sample,
      board: [Board.all.sample, nil].sample)

    ticket.comments.create(content: Faker::Lorem::paragraph(),
      status_id: board.project.statuses.sample.id,
      user_id: board.project.members.sample.user_id,
      assignee_id: [board.project.members.sample.user_id, nil].sample,
      cost: [Comment::COSTS.values.sample, nil].sample,
      board: [Board.all.sample, nil].sample)

    # assign the ticket to this board using a comment
    ticket.comments.create(
      content: Faker::Lorem::paragraph(),
      status_id: board.project.statuses.sample.id,
      user_id: board.project.members.sample.user_id,
      assignee_id: [board.project.members.sample.user_id, nil].sample,
      cost: [Comment::COSTS.values.sample, nil].sample,
      board: board)
  end
end

p "all done. #{Project.count} projects, #{Board.count} boards, #{Ticket.count} tickets, #{Comment.count} comments, #{User.count} users."

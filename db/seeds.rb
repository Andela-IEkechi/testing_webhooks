require "faker"

Asset.delete_all
Comment.delete_all
Ticket.delete_all
Board.delete_all
Status.delete_all
Project.delete_all
Account.delete_all
User.delete_all
Member.delete_all

user = User.create(email: "user@example.com", password: "password")
user.skip_confirmation_notification!
user.confirm!

Member::ROLES.each do |role|
  project = Project.create(name: "#{role} project")
  user.memberships.create(project: project, role: role)
end

# create a few more users
4.times do
  user = User.create(email: Faker::Internet.email, password: "password")
  user.skip_confirmation_notification!
  user.confirm!
end

#assign them to projects
User.where.not(:id => user.id).find_each do |user|
  Project.find_each do |proj|
    proj.members.create(user_id: user.id, role: Member::ROLES.sample)
  end
end

#create a few boards for every project
Project.find_each do |proj|
  proj.boards.create(name: Faker::Lorem.word)
  proj.boards.create(name: Faker::Lorem.word)
  proj.boards.create(name: Faker::Lorem.word)
end

#create a few tickets for every board
Board.find_each do |board|
  3.times do
    ticket = Ticket.create(name: Faker::Lorem.sentence(3), project_id: board.project_id)
    ticket.comments.create(content: Faker::Lorem::paragraph(), status_id: board.project.statuses.sample.id, user_id: board.project.members.sample.user_id, board_id: board.id)
    # create a few comments for this ticket
    ticket.comments.create(content: Faker::Lorem::paragraph(), status_id: board.project.statuses.sample.id, user_id: board.project.members.sample.user_id)
    ticket.comments.create(content: Faker::Lorem::paragraph(), status_id: board.project.statuses.sample.id, user_id: board.project.members.sample.user_id)
  end
end

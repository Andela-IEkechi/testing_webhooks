require "faker"

Asset.delete_all
Comment.delete_all
Ticket.delete_all
Board.delete_all
TicketStatus.delete_all
Project.delete_all
Account.delete_all
User.delete_all
Membership.delete_all

user = User.create(email: "user@example.com", password: "password")
user.skip_confirmation_notification!
user.confirm!

Membership::ROLES.each do |role|
  project = Project.create(title: "#{role} project")
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
    proj.memberships.create(user_id: user.id, role: Membership::ROLES.sample)
  end
end

#create a few boards for every project
Project.find_each do |proj|
  proj.boards.create(name: Faker::Lorem.word)
  proj.boards.create(name: Faker::Lorem.word)
  proj.boards.create(name: Faker::Lorem.word)
end


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#create a user
p "creating users..."
User.find_each(&:destroy)
restricted = User.create(:email => 'restricted@example.com', :password => 'secret', :password_confirmation => 'secret', :terms => true)
restricted.confirm
regular = User.create(:email => 'regular@example.com', :password => 'secret', :password_confirmation => 'secret', :terms => true)
regular.confirm
admin = User.create(:email => 'admin@example.com', :password => 'secret', :password_confirmation => 'secret', :terms => true)
admin.confirm

#create some projects
p "creating projects..."
Project.find_each(&:destroy)
mhp = admin.projects.create(:title => "Manhattan Project")
app = admin.projects.create(:title => "Allan Parsons Project")
app.memberships.create(:user_id => restricted.id, :role => 'restricted')
app.memberships.create(:user_id => regular.id, :role => 'regular')

#create a test sprint
p "creating sprints..."
Sprint.find_each(&:destroy)
3.times do
  sprint = mhp.sprints.build(:goal => Faker::Lorem.sentence)
  sprint.due_on = Date.today + 7
  sprint.save!
end

sprint = mhp.sprints.last

#create some dummy tickets
p "creating tickets..."
Ticket.find_each(&:destroy)
15.times do |x|
  ticket = mhp.tickets.create(title: Faker::Lorem.words(4).join(' '))
  (1..7).to_a.each do |x| #at least more than 6 comments, so we can enable folding
    comment = ticket.comments.build(:body => Faker::Lorem.paragraph, :status_id => mhp.ticket_statuses.first.id)
    comment.sprint = sprint if x == 1
    comment.user = admin
    comment.assignee = regular if x == 20
    comment.save
  end
end





# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#create a user
User.find_each(&:destroy)
jlr = User.create(:email => 'jean@shuntyard.co.za', :password => 'secret', :password_confirmation => 'secret', :terms => true)
jlr.confirm!

barbara = User.create(:email => 'barbara@shuntyard.co.za', :password => 'conductor', :password_confirmation => 'conductor', :terms => true)
barbara.confirm!
user = User.create(:email => 'user@example.com', :password => 'secret', :password_confirmation => 'secret', :terms => true)
user.confirm!

restricted = User.create(:email => 'restricted@example.com', :password => 'secret', :password_confirmation => 'secret', :terms => true)
restricted.confirm!
regular = User.create(:email => 'regular@example.com', :password => 'secret', :password_confirmation => 'secret', :terms => true)
regular.confirm!
admin = User.create(:email => 'admin@example.com', :password => 'secret', :password_confirmation => 'secret', :terms => true)
admin.confirm!

#create some projects
Project.find_each(&:destroy)
mhp = jlr.projects.create(:title => "Manhattan Project")
app = jlr.projects.create(:title => "Allan Parsons Project")
app.memberships.create(:user_id => restricted.id, :role => 'restricted')
app.memberships.create(:user_id => admin.id, :role => 'admin')
app.memberships.create(:user_id => regular.id, :role => 'regular')

#create a test sprint
Sprint.find_each(&:destroy)
3.times do
  sprint = mhp.sprints.build(:goal => [*('A'..'Z')].sample(12).join)
  sprint.due_on = Date.today + 7
  sprint.save!
end

sprint = mhp.sprints.last

#create some dummy tickets
Ticket.find_each(&:destroy)
100.times do |x|
  title = [*('A'..'Z')].sample(8).join
  ticket = mhp.tickets.create(title: title)
  (1..20).to_a.each do |x|
    comment = ticket.comments.build(:body => 'a comment', :status_id => mhp.ticket_statuses.first.id)
    comment.sprint = sprint if x == 1
    comment.user = jlr
    comment.assignee = jlr if x == 20
    comment.save
  end
end




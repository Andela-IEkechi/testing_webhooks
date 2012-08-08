# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#create a user
User.find_each(&:destroy)
jlr = User.create(:email => 'jean@shuntyard.co.za', :password => 'secret', :password_confirmation => 'secret')
jlr.confirm!

joe = User.create(:email => 'joe@example.com', :password => 'secret', :password_confirmation => 'secret')
joe.confirm!
sue = User.create(:email => 'sue@example.com', :password => 'secret', :password_confirmation => 'secret')
sue.confirm!

#create some projects
Project.find_each(&:destroy)
mhp = jlr.projects.create(:title => "Manhattan Project")
app = jlr.projects.create(:title => "Allan Parsons Project")


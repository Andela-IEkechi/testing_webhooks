# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#create a user
jlr = User.create(:email => 'jean@shuntyard.co.za', :password => 'secret', :password_confirmation => 'secret')
jlr.confirm!

#create some projects
mhp = jlr.projects.create(:title => "Manhattan Project")
app = jlr.projects.create(:title => "Allan Parsons Project")


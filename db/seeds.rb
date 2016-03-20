# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


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
User.find_each {|u|
  u.skip_confirmation_notification!
  u.confirm!
}

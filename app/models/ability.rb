class Ability
  include CanCan::Ability

  def initialize(user)
  	can :manage, User
  	can :manage, Account

  	can :read, Project, :memberships => {:user_id => user.id}
  	can :manage, Project, :memberships => {:user_id => user.id, :role => 'admin'}
		can :manage, Project, :user_id => user.id

  	can :manage, Membership

  	can :manage, Feature
  	can :manage, Sprint

  	can :read, Ticket
  	can :manage, Ticket do |ticket|
		  (ticket.user.id rescue nil) == user.id
		end
		can :read, Comment
  	can :manage, Comment, :user_id => user.id


  end

end
class Ability
  include CanCan::Ability

  def initialize(user)
  	can :manage, User
  	can :manage, Account

  	can :manage, Membership, :user_id => user.id

    can :read, Project, :memberships => {:user_id => user.id}
    can :manage, Project, :memberships => {:user_id => user.id, :role => 'admin'}
    #even if we made the project, if we are no longer admins, we no can longer manage it
    #can :manage, Project, :user_id => user.id

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
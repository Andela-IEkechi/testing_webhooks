class Ability
  include CanCan::Ability

  def initialize(user)
  	can :manage, User, :id => user.id
  	can :manage, Account, :user => {:id => user.id}

    can :read, Project, :memberships => {:user_id => user.id}
    can :manage, Project, :memberships => {:user_id => user.id, :role => 'admin'}
    #even if we made the project, if we are no longer admins, we no can longer manage it
    #can :manage, Project, :user_id => user.id

    #anyone can manage membership to a project if they are an admin
  	can :manage, Membership, :project => {:user_id => user.id, :role => 'admin'}

    #anyone can read features and sprints on projects where they are members
  	can :read, Feature, :project => {:memberships => {:user_id => user.id}}
    can :read, Sprint, :project => {:memberships => {:user_id => user.id}}

    #only admin users can manage sprints and features and only on projects where they are members
    #we explicitly dont care who owns the project, no admin = no access
    can :manage, Feature, :project => {:memberships => {:user_id => user.id, :role => ['admin']}}
    can :manage, Sprint, :project => {:memberships => {:user_id => user.id, :role => ['admin']}}

  	#anyone can read tickets on projects where they are a member
    can :read, Ticket, :project => {:memberships => {:user_id => user.id}}

    #users can manage tickets which belong to them
  	can :manage, Ticket do |ticket|
		  (ticket.user.id rescue nil) == user.id
		end

    #anyone can read a comments on a ticket which belongs to a project which they are a member of
		can :read, Comment, :ticket => {:project => {:memberships => {:user_id => user.id}}}

    #anyone can manage a comment which belongs to them
  	can :manage, Comment, :user_id => user.id

  end

end

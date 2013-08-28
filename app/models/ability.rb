class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, User, :id => user.id
    can :manage, Account, :user => {:id => user.id}

    can :read, Project, :private => true, :memberships => {:user_id => user.id}
    can :read, Project, :private => false
    can :manage, Project, :memberships => {:user_id => user.id, :role => 'admin'}
    can :create, Project
    can :invite, Project

    #even if we made the project, if we are no longer admins, we no can longer manage it
    #can :manage, Project, :user_id => user.id

    #anyone can manage membership to a project if they are an admin
    can :manage, Membership, :project => {:user_id => user.id, :role => 'admin'}

    #anyone can read features and sprints on projects where they are members
    can :read, Feature, :project => {:private => true, :memberships => {:user_id => user.id}}
    can :read, Feature, :project => {:private => false }

    can :read, Sprint, :project => {:private => true, :memberships => {:user_id => user.id}}
    can :read, Sprint, :project => {:private => false }

    #only admin users can manage sprints and features and only on projects where they are members
    #we explicitly dont care who owns the project, no admin = no access
    can :manage, Feature, :project => {:memberships => {:user_id => user.id, :role => 'admin'}}
    can :manage, Sprint, :project => {:memberships => {:user_id => user.id, :role => 'admin'}}

    #anyone can read tickets on projects where they are a member
    can :read, Ticket, :project => {:private => true, :memberships => {:user_id => user.id}}
    can :read, Ticket, :project => {:private => false }

    #users can manage tickets which belong to them
    can :create, Ticket
    can :manage, Ticket do |ticket|
      (ticket.user_id == user.id) && ticket.project.memberships.for_user(user.id) && !ticket.project.memberships.for_user(user.id).first.restricted?
    end

    #anyone can read a comments on a ticket which belongs to a project which they are a member of
    can :read, Comment, :ticket => {:project => {:memberships => {:user_id => user.id}}}

    #anyone can manage a comment which belongs to them
    can :manage, Comment, :user_id => user.id, :ticket => {:project => {:memberships => {:user_id => user.id, :role => ['admin', 'regular']}}}

    #users can manage their own overviews
    can :manage, Overview, :user_id => user.id

  end

end

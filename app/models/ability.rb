class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end

    can :manage, User, :id => user.id
    can :manage, Account, :user_id => user.id

    can :manage, Project, :user_id => user.id
    can :create, Project if user.confirmed?
    can :read, Project #we refine the perms in the controller, it's too trickey here :(

    can :manage, Feature
    can :manage, Sprint

    can [:read, :create], Ticket
    can :manage, Ticket do |ticket|
      (ticket.user.id rescue nil) == user.id
    end

    can [:read, :create], Comment
    can :manage, Comment, :user_id => user.id

    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end

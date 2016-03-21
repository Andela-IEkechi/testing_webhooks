class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    #TODO: we should check if the user's account permits it, they might be at capacity
    true
  end

  def update?
    #TODO: we should check if the user is an admin or an owner of the project
    true
  end

end

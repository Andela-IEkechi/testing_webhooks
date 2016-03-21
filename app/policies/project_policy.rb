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

end

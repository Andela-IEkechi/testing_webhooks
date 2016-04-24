class ProjectPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.joins(:members).where(members: {user_id: user.id})
    end
  end

  def create?
    true
  end
  
  def show?
    return false unless record.is_a?(Project)
    record.members.where(user: user).any?
  end
  
  def update?
    return false unless record.is_a?(Project)
    record.members.owners.where(user: user).any? || record.members.administrators.where(user: user).any?
  end
  
  def delete?
    return false unless record.is_a?(Project)
    record.members.owners.where(user: user).any?
  end

end

class ApiKeyPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.joins(project: :members).where(members: { user_id: user })
    end
  end

  def create?
    return false unless record.is_a?(ApiKey)
    record.project.members.unrestricted.where(user: user).any?
  end

  def show?
    return false unless record.is_a?(ApiKey)
    record.project.members.where(user: user).any?
  end

  def destroy?
    return false unless record.is_a?(ApiKey)
    record.project.members.owners.where(user: user).any? || record.project.members.administrators.where(user: user).any?
  end
end

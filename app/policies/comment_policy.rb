class CommentPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.joins(ticket: {project: :members}).where(members: {user_id: user})
    end
  end

  def create?
    return false unless record.is_a?(Comment)
    record.ticket.project.members.unrestricted.where(user: user).any?
  end
  
  def show?
    return false unless record.is_a?(Comment)
    record.ticket.project.members.where(user: user).any?
  end
  
  def update?
    return false unless record.is_a?(Comment)
    show? && 
      (
        record.ticket.project.members.owners.where(user: user).any? || 
        record.ticket.project.members.administrators.where(user: user).any? ||
        (record.ticket.project.members.where(user: record.commenter).any? && (record.commenter == user))
      )
  end
  
  def destroy?
    return false unless record.is_a?(Comment)
    record.ticket.project.members.owners.where(user: user).any? || 
    record.ticket.project.members.administrators.where(user: user).any? ||
    (record.ticket.project.members.where(user: record.commenter).any? && (record.commenter == user))
  end

end

class AttachmentPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.joins(ticket: { project: :members }).where(members: {user_id: user.id})
    end
  end

  def show?
    return false unless record.is_a?(Attachment)
    record.ticket.project.members.where(user: user).any?
  end

  def create?
    return false unless record.is_a?(Attachment)
    record.ticket && record.ticket.project && (
      record.ticket.project.members.owners.where(user: user).any? ||
      record.ticket.project.members.administrators.where(user: user).any? || (
        record.ticket.project.members.regulars.where(user: record.comment.commenter).any? &&
        (record.comment.commenter == user)
      )
    )
  end

  def destroy?
    create?
  end

  def download?
    show?
  end
end

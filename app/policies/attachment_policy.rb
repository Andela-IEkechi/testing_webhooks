class AttachmentPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.joins(comment: { ticket: { project: :members } }).where(members: {user_id: user})
    end
  end

  def show?
    return false unless record.is_a?(Attachment)
    record.comment.ticket.project.members.where(user: user).any?
  end

  def attach_file_to_comment?
    return false unless record.is_a?(Attachment)
    (
    record.comment.ticket.project.members.owners.where(user: user).any? ||
        record.comment.ticket.project.members.administrators.where(user: user).any? ||
        (record.comment.ticket.project.members.regulars.where(user: record.comment.commenter).any? &&
            (record.comment.commenter == user))
    )
  end

  def remove_file_from_comment?
    return false unless record.is_a?(Attachment)
    (
    record.comment.ticket.project.members.owners.where(user: user).any? ||
        record.comment.ticket.project.members.administrators.where(user: user).any? ||
        (record.comment.ticket.project.members.regulars.where(user: record.comment.commenter).any? &&
            (record.comment.commenter == user))
    )
  end
end

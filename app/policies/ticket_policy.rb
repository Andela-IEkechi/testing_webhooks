class TicketPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.joins(project: :members).where(members: {user_id: user})
    end
  end

  def create?
    return false unless record.is_a?(Ticket)
    record.project.members.unrestricted.where(user: user).any?
  end
  
  def show?
    return false unless record.is_a?(Ticket)
    record.project.members.where(user: user).any?
  end
  
  def update?
    return false unless record.is_a?(Ticket)
    show? && 
      (
        # project owners can edit a ticket
        record.project.members.owners.where(user: user).any? ||
        # project admins can edit a ticket
        record.project.members.administrators.where(user: user).any? ||
        #the ticket creator can also edit the ticket
        (record.project.members.regulars.where(user: record.creator).any? && (record.creator == user)) ||
        #the ticket assignee can also edit the ticket
        (record.project.members.regulars.where(user: record.assignee).any? && (record.assignee == user))
      )
  end
  
  def destroy?
    return false unless record.is_a?(Ticket)
    # NOTE: project owners and project administrators may delete a ticket.
    record.project.members.owners.where(user: user).any? || record.project.members.administrators.where(user: user).any?
  end

end

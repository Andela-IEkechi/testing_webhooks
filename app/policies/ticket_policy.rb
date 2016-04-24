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
        record.project.members.where(user: record.creator).any? ||
        #the ticket assignee can also edit the ticket
        record.project.members.where(user: record.assignee).any?
      )
  end
  
  def delete?
    return false unless record.is_a?(Ticket)
    record.members.owners.where(user: user).any?
  end

end

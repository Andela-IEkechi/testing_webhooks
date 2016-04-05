class TicketPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    true
  end

  def create?
    new?
  end

  def update?
    true
  end

  def edit?
    update?
  end
end

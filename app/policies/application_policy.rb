class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user   = user
    @record = record
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.empty
    end
  end  

  def create?
    false
  end
  
  def show?
    false
  end
  
  def update?
    false
  end
  
  def delete?
    false
  end  
end
class DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end


  def download?
    #test if the user is a member of the project, but not a restricted user
    true
  end
end

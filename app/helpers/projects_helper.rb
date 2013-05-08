module ProjectsHelper

  def valid_transfer_members(project)
    project.memberships.collect(&:user).select(&:confirmed?).reject{|u| u.id == current_user.id}
  end

  def can_transfer_project?(project)
    valid_transfer_members(project).any?
  end
end

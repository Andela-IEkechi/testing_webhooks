module ProjectsHelper

  def valid_transfer_members(project)
    project.memberships.collect(&:user).select(&:confirmed?).reject{|u| u.id == current_user.id}
  end

  def can_transfer_project?(project)
    (project.user_id == current_user.id) && valid_transfer_members(project).any?
  end

  def can_delete_project?(project)
    project.user_id == current_user.id
  end
end

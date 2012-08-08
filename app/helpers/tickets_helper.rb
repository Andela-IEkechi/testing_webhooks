module TicketsHelper

  def ticket_parent_path(ticket)
    if ticket.feature
      project_feature_path(ticket.project, ticket.feature)
    else
      project_path(ticket.project)
    end
  end

  def ticket_edit_path(ticket)
    if ticket.feature
      project_feature_path(@ticket.project, @ticket.feature)
    else
      project_path(@ticket.project)
    end
  end

  def ticket_new_path(ticket)
    if ticket.feature
      new_project_feature_path(@ticket.project, @ticket.feature)
    else
      new_project_path(@ticket.project)
    end
  end

end

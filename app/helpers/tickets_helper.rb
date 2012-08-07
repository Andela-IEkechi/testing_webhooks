module TicketsHelper

  def parent_path(ticket)
    return project_path(ticket.project) if ticket.project
    return project_feature_path(ticket.project, ticket.feature) if ticket.feature
    tickets_path()
  end


end

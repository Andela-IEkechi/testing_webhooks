module TicketsHelper

  def parent_path(ticket)
    case ticket.ticketable_type
    when 'Project'
      projects_path(ticket.ticketable)
    when 'Feature'
      project_feature_path(ticket.ticketable.project, ticket.ticketable)
    else
      tickets_path()
    end
  end
end

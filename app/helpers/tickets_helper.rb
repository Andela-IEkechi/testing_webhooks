module TicketsHelper

  def cost_short(cost)
    case cost
    when 0
      "--"
    else
      cost.to_s
    end
  end

  def ticket_url_params(options={})
    {
      :paginate => true,
      :show_search => !@overview,
      :title => (@overview && options[:project_id] && Project.find(options[:project_id]).title) || 'Tickets',
      :project_id => @project && @project.id,
      :sprint_id => @sprint && @sprint.to_param,
      :overview_id => @overview && @overview.id,
      :query => ( @term || (@overview && @overview.filter))
    }.merge(options)
  end

  def ticket_load_link(name, url_options={}, link_options={})
    url_options = ticket_url_params(url_options)
    link_options = {
      :remote => true
    }.merge(link_options)
    link_to name, project_tickets_path(url_options), link_options
  end

  def assignee(ticket, include_github_login=false)
    return '' unless ticket.assignee

    parts = []
    if ticket.project.public?
      parts << ticket.assignee.obfuscated
    else
      parts << ticket.assignee.to_s
    end
    parts << ticket.assignee.github_login
    parts.compact.join(' - ')
  end
end

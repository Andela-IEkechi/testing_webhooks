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
    project_title = (@project || Project.find(options[:project_id])).title rescue nil
    {
      :show_search => !@overview,
      :title => (@overview && project_title) || 'Tickets',
      :project_id => @project && @project.id,
      :sprint_id => @sprint && @sprint.to_param,
      :overview_id => @overview && @overview.id,
      :query => "#{@query} #{(@overview && @overview.filter)}"
    }.merge(options)
  end

  def ticket_load_link(name, url_options={}, link_options={})
    url_options = ticket_url_params(url_options)
    link_options = {
      :remote => true
    }.merge(link_options)
    link_to name, project_tickets_path(url_options), link_options
  end

  def assignee(ticket)
    return '' unless ticket.assignee

    if ticket.project.public?
      ticket.assignee.obfuscated
    else
      ticket.assignee.to_s
    end
  end

end

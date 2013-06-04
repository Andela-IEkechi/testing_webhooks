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
      :feature_id => @feature && @feature.to_param,
      :overview_id => @overview && @overview.id,
      :q => {:title_cont => @term || (@overview && @overview.filter)}
    }.merge(options)
  end

  def ticket_load_link(name, url_options={}, link_options={})
    url_options = ticket_url_params(url_options)
    link_options = {
      :remote => true
    }.merge(link_options)
    link_to name, project_tickets_path(url_options), link_options
  end
end

module TabHeadingHelper

  # Returns a string for the page title, if any of @ticket, @sprint or @project
  # is defined, otherwise just 'Conductor'

  def tab_heading
    if @ticket
      "Ticket #{@ticket.id} - #{@ticket}"
    elsif @sprint
      "Sprint #{@sprint.id} - #{@sprint}"
    elsif @project
      "Project #{@project.id} - #{@project}"
    else
      "Conductor"
    end
  end

end

module TabHeadingHelper

  # Returns a string for the page title, if any of @ticket, @sprint or @project
  # is defined, otherwise just 'Conductor'

  def tab_heading
    if @ticket
      @ticket.id ? "##{@ticket.id} - #{@ticket}" : "New ticket"
    elsif @sprint
      @sprint.id ? "Sprint - #{@sprint}" : "New sprint"
    elsif @feature
      @feature.id ? "Feature - #{@feature}" : "New feature"
    elsif @project
      @project.id ? "Project - #{@project}" : "New project"
    else
      "Conductor"
    end
  end

end

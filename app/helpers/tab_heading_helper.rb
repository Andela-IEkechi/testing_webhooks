module TabHeadingHelper

  # Returns a string for the page title, if any of @ticket, @sprint or @project
  # is defined, otherwise just 'Conductor'

  def tab_heading
    if @ticket
      "##{@ticket.id} - #{@ticket}"
    elsif @sprint
      "Sprint - #{@sprint}"
    elsif @feature
      "Feature - #{@feature}"
    elsif @project
      "#{@project}"
    else
      "Conductor"
    end
  end

end

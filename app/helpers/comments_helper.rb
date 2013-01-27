module CommentsHelper
  def cost_long(cost)
    case cost
    when 0
      "unknown"
    else
      cost.to_s
    end
  end

  def cancel_link
    if @feature
      link_to 'cancel', project_feature_path(@ticket.project, @feature), :class => 'btn', :title => 'back to the feature'
    elsif @sprint
      link_to 'cancel', project_sprint_path(@ticket.project, @sprint), :class => 'btn', :title => 'back to the sprint'
    elsif !@ticket.new_record?
      link_to 'cancel', project_ticket_path(@ticket.project, @ticket), :class => 'btn', :title => 'back to the ticket'
    else
      link_to 'cancel', project_path(@ticket.project), :class => 'btn', :title => 'back to the project'
    end
  end

  def author(comment)
    return comment.user.to_s if !comment.user.nil?
    return comment.api_key_name unless comment.api_key_name.blank?
    'anonymous'
  end
end

module CommentsHelper
  def cost_long(cost)
    case cost
    when 0
      "unknown"
    else
      cost.to_s
    end
  end

  def change_set(comment)
    changeset = {:user => comment.user.to_s}
    previous = comment.previous
    #get what changed
    [:status_id, :feature_id, :sprint_id, :assignee_id, :cost, :assets].each do |attr|
      now = comment.send(attr)
      if previous
        was = previous.send(attr)
        changeset[attr] = [now] if now != was
      else
        changeset[attr] = [now]
      end
    end
    changeset
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
    return "#{comment.commenter} via #{comment.api_key_name}" if !comment.api_key_name.blank?
    comment.user || 'anonymous'
  end
end

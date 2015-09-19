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
    changeset = {}
    previous = comment.previous
    #get what changed
    [:status_id, :sprint_id, :assignee_id, :cost, :assets].each do |attr|
      now = comment.send(attr)
      if previous
        was = previous.send(attr)
        changeset[attr] = [now] if now != was
      else
        changeset[attr] = [now]
      end
    end

    #add tags to the change set
    if comment.tag_list.sort != (previous.tag_list.sort rescue [])
      changeset[:tags_added] = (comment.tag_list - previous.tag_list rescue comment.tag_list)
      changeset[:tags_removed] = (previous.tag_list - comment.tag_list rescue [])
    end

    changeset
  end

  def cancel_link
    if @sprint
      link_to 'cancel', project_sprint_path(@ticket.project, @sprint), :class => 'btn', :title => 'back to the sprint'
    elsif !@ticket.new_record?
      link_to 'cancel', project_ticket_path(@ticket.project, @ticket), :class => 'btn', :title => 'back to the ticket'
    else
      link_to 'cancel', project_path(@ticket.project), :class => 'btn', :title => 'back to the project'
    end
  end

  def author(comment)
    return "#{comment.commenter} via #{comment.api_key_name}" if !comment.api_key_name.blank?
    if comment.project.public?
      comment.user.obfuscated || 'anonymous'
    else
      comment.user || 'anonymous'
    end
  end
end

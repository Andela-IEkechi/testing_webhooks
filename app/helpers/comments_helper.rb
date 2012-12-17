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
end

module TicketsHelper
  def cost_short(cost)
    case cost
    when 0
      "--"
    else
      cost.to_s
    end
  end

  def context_type
    return @sprint.class.name if @sprint
    return @feature.class.name if @feature
    return @project.class.name if @project
    nil
  end

  def context_id
    return @sprint.id if @sprint
    return @feature.id if @feature
    return @project.id if @project
    nil
  end
end

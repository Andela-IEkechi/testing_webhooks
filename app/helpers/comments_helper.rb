module CommentsHelper
  def cost_long(cost)
    case cost
    when 0
      "unknown"
    else
      cost.to_s
    end
  end
end

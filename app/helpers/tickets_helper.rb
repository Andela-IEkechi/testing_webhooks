module TicketsHelper
  def cost_short(cost)
    case cost
    when 0
      "--"
    else
      cost.to_s
    end
  end


end

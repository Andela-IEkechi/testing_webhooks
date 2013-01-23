module TicketHolderHelper

  def completion_percentage(holder)
    return nil unless holder.respond_to?(:assigned_tickets) && holder.respond_to?(:closed_tickets)
    return 0 if holder.assigned_tickets.count == 0
    (100.0*holder.closed_tickets.count/(holder.assigned_tickets.count)).round(0)
  end

  def completion_message(holder)
    return nil unless holder.respond_to?(:assigned_tickets) && holder.respond_to?(:closed_tickets)
    return "nothing assigned" if holder.assigned_tickets.count == 0
    "#{holder.closed_tickets.count} of #{holder.assigned_tickets.count} tickets closed"
  end

  #helps to set the color for the progress bar
  def completion_state(holder)
    case completion_percentage(holder)
    when 0
      return "grey"
    when 1..25
      return "danger"
    when 26..75
      return "warning"
    else
      return "success"
    end
  end
end
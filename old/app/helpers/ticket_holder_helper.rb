module TicketHolderHelper

  def completion_message(holder)
    return "nothing assigned" if holder.assigned_tickets.blank?
    "#{holder.closed_ticket_count} of #{holder.ticket_count} tickets closed"
  end

  #helps to set the color for the progress bar
  def completion_state(holder)
    case holder.progess_count
    when 0..25
      return "danger"
    when 26..75
      return "warning"
    else
      return "success"
    end
  end

  def completion_str(holder)
    return "not started" if holder.progess_count == 0
    "#{holder.progess_count}%"
  end
end
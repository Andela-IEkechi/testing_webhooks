# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class BoardTicketsChannel < ApplicationCable::Channel
  def subscribed
    # try and stream from all available boards
    self.available_board_ids.each do |board_id|
      stream_from "board:#{board_id}:tickets"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def moved(data)
    #find the ticket
    data = data.with_indifferent_access
    tickets = TicketPolicy::Scope.new(current_user, Ticket).resolve
    ticket = tickets.find(data[:ticket_id])

    status = ticket.project.statuses.find(data[:status_id])
    order = data[:order].to_i

    #move the ticket to the new status if we can
    ticket.move!(status, order, current_user) if ticket && status
  end

  protected

  def available_board_ids
    current_user.projects.includes(:boards).collect{|proj| proj.boards.collect(&:id)}.flatten
  end

end

# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class BoardTicketsChannel < ApplicationCable::Channel
  def subscribed
    # try and stream from all available boards
    self.available_boards.each do |board_id|
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

    #find the status
    status = ticket.project.statuses.find(data[:status_id])

    #move the ticket to the new status if we can
    ticket.move!(status, current_user) if ticket && status

    #broadcast the ticket info, it might have failed to move, thats ok.
    ActionCable.server.broadcast "board:#{ticket.board_id}:tickets", ticket.broadcast_data
  end

  protected

  def available_boards
    current_user.projects.includes(:boards).collect{|proj| proj.boards.collect(&:id)}.flatten
  end

end

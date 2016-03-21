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

  def retrieve(data)
    #TODO: make sure the user can access the board! Use policies!
    board = Board.find(data[:board_id])

    # broadcast all the tickets on the particular board
    if board.tickets.any?
      ActionCable.server.broadcast "board:#{board.id}:tickets", board.tickets.map{|t| t.attributes}
    end
  end

  protected

  def available_boards
    current_user.projects.includes(:boards).collect{|proj| proj.boards.collect(&:id)}.flatten
  end

end

module Broadcast::Ticket
  extend ActiveSupport::Concern

  included do
    # after_create  :broadcast_create
    # after_update  :broadcast_update
    # after_destroy :broadcast_destroy

    def broadcast_data
      as_json(include: [:status, :assignee, :user, :board], methods: [:cost, :cost_key])
    end

    #tell boards and projects there is a new ticket to display
    def broadcast_create
      ActionCable.server.broadcast "project:#{project.id}:tickets", {create: broadcast_data} if project.present?
      ActionCable.server.broadcast "board:#{board.id}:tickets", {create: broadcast_data} if board.present?
    end

    #tell boards and projects there is a new ticket to display
    def broadcast_update
      previous = comments.order(id: :desc).limit(2).last
      current = last_comment
      # if there was no board, or it changed
      if previous.board.nil? || (previous.board.id != current.board.id)
        ActionCable.server.broadcast "board:#{previous.board.id}:tickets", {destroy: broadcast_data} if previous.board.present?
        ActionCable.server.broadcast "board:#{current.board.id}:tickets", {create: broadcast_data} if current.board.present?
      else #there was a board and it was the same
        ActionCable.server.broadcast "board:#{current.board.id}:tickets", {update: broadcast_data} if current.board.present?
      end

      ActionCable.server.broadcast "project:#{project.id}:tickets", {update: broadcast_data} if project.present?
    end

    #tell boards and projects when a ticket is destroyed
    def broadcast_destroy
      ActionCable.server.broadcast "project:#{project.id}:tickets", {destroy: broadcast_data} if project.present?
      ActionCable.server.broadcast "board:#{board.id}:tickets", {destroy: broadcast_data} if board.present?
    end
  end
end

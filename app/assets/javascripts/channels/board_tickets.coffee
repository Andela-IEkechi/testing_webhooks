App.board_tickets = App.cable.subscriptions.create "BoardTicketsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    # @retrieve()

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log "BoardTicketsChannel... #{data}"

  retrieve: (board_id)->
    # Calls `BoardTicketsChannel#retrieve(data)` on the server
    console.log "retrieving board: #{board_id}"
      @perform("retrieve", board_id: board_id)

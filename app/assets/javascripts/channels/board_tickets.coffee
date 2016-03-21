App.board_tickets = App.cable.subscriptions.create "BoardTicketsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    @retrieve()

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log "BoardTicketsChannel... #{data}"

  retrieve: ->
    # Calls `BoardTicketsChannel#retrieve(data)` on the server
    for board in $(".board")
      console.log "retrieving board: #{board.data("board-id")}"
      @perform("retrieve", board_id: board.data("board-id"))

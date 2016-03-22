App.board_tickets = App.cable.subscriptions.create "BoardTicketsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    # @retrieve()

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log "BoardTicketsChannel... #{data}"

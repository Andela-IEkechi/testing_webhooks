App.board_tickets = App.cable.subscriptions.create "BoardTicketsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    @install()

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $(".board").trigger("board:ticket:updated", data)

  moved: (data) ->
    # tell the server we moved a ticket
    @perform('moved', data)

  install: ->
    $(document).on "board:ticket:moved", ".board", (event, data)=>
      @moved(data)

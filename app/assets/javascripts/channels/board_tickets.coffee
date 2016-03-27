App.board_tickets = App.cable.subscriptions.create "BoardTicketsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    @install()

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    #TODO: we should ignore broadcasts which are caused by our own actions. Perhaps compare the data.user.id to ours  ?
    if data.create
      $(".board").trigger("board:ticket:create", data.create)
    else if data.update
      $(".board").trigger("board:ticket:update", data.update)
    else if data.destroy
      $(".board").trigger("board:ticket:destroy", data.destroy)

  moved: (data) ->
    # tell the server we moved a ticket
    @perform('moved', data)

  install: ->
    $(document).on "board:ticket:moved", ".board", (event, data)=>
      @moved(data)

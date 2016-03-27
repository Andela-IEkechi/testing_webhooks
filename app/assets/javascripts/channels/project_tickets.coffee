App.project_tickets = App.cable.subscriptions.create "ProjectTicketsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    @install()

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.create
      $(".project").trigger("project:ticket:create", data)
    else if data.update
      $(".project").trigger("project:ticket:update", data)
    else if data.destroy
      $(".project").trigger("project:ticket:destroy", data)

  install: ->
    # no callbacks to register yet

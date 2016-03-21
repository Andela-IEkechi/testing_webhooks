App.projects = App.cable.subscriptions.create "ProjectsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel

    alert_type = data.success ? 'alert-success' : 'alert-danger'
    data_message = data.success if data.success
    data_message = data.error if data.error
    msg = "
      <div class='alert alert-success #{alert_type} alert-dismissable fade in'>
        <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>
        #{data_message}
      </div>
    "

    $("#flasher").html(msg)

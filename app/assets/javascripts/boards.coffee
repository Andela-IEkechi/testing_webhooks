context_name = ".board"
context = (selector) ->
  if selector
    $(context_name).find(selector)
  else
    $(context_name)

updateTicket = (item)->
# send an ajax update to the ticket with it's relevant order/column.
# let the controller deal with adjusting all tickets.
  console.log item

build_ticket_html = (template, ticket)->
  html = $($('<textarea />').html(template).text())

  html.find(".id").html(ticket.id)
  html.find(".title").html(ticket.title)
  if ticket.assignee
    html.find(".assignee").html(ticket.assignee.email)
  else
    html.find(".assignee").html("unassigned")
  html.find(".user").html(ticket.user.email)
  return html[0].outerHTML

fetch_board = (board)->
  #get the url we need to pull the board info from
  board_url = $(board).data('board-url')
  $.ajax board_url,
    datatype: "json",
    method: "GET",
    success: (data)->
      template = $(board).data("ticket-template")
      for ticket in data.tickets
        ticket_html = build_ticket_html(template, ticket)
        # insert the ticket html into the correct column
        column = $(board).find("td[data-status-id='#{ticket.status.id}']")
        column.append(ticket_html)

$ ->
  #load the board content after the page is loaded
  for board in context()
    fetch_board(board)
    board_id = $(board).data('board-id')
    $(board).find("tbody tr td").sortable({
      connectWith: "[data-board-id='#{board_id}'] .connectedSortable",
      stop: (event, ui)->
        updateTicket(ui.item[0])
      })

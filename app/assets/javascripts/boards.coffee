context_name = ".board"
context = (selector) ->
  if selector
    $(context_name).find(selector)
  else
    $(context_name)

construct_ticket_html = (template, ticket)->
  ticket_html = $($('<textarea />').html(template).text())
  # we have to use attr here, using .data does not update the dom
  ticket_html.attr("data-id", ticket.id)
  ticket_html.find(".id").html(ticket.id)
  ticket_html.find(".title").html(ticket.title)
  if ticket.assignee
    ticket_html.find(".assignee").html(ticket.assignee.email)
  else
    ticket_html.find(".assignee").html("unassigned")
  ticket_html.find(".user").html(ticket.user.email)
  return ticket_html[0].outerHTML

deconstruct_ticket_html = (ticket_html)->
  ticket = {}
  ticket.ticket_id = $(ticket_html).data("id")
  ticket.status_id = $(ticket_html).parents('td').data("status-id")
  ticket

fetch_board = (board)->
  #get the url we need to pull the board info from
  board_url = $(board).data('board-url')
  $.ajax board_url,
    datatype: "json",
    method: "GET",
    success: (data)->
      template = $(board).data("ticket-template")
      for ticket in data.tickets
        ticket_html = construct_ticket_html(template, ticket)
        # insert the ticket html into the correct column
        column = $(board).find("td[data-status-id='#{ticket.status.id}']")
        column.append(ticket_html)

$(document).on "click", ".boards-nav a.board-settings", (event)->
  event.preventDefault()
  active_board_id = $(this).parents('ul').find('.active').attr('href')
  $("#{active_board_id}").find('form').show()
  $("#{active_board_id}").find('table').hide()

$(document).on "board:ticket:updated", "#{context_name}", (event, ticket)->
  #find the ticket that was updated, and remove it from the board
  context(".ticket[data-id=#{ticket.id}]").remove()

  #find the right board
  board = context("table[data-board-id=#{ticket.board_id}]")
  #construct a new ticket and place it on the board
  template = board.data("ticket-template")
  console.log template
  ticket_html = construct_ticket_html(template, ticket)
  column = $(board).find("td[data-status-id='#{ticket.status.id}']")
  column.append(ticket_html)

$ ->
  #load the board content after the page is loaded
  for board in context("table")
    fetch_board(board)
    board_id = $(board).data('board-id')
    $(board).find("tbody tr td").sortable({
      connectWith: "[data-board-id='#{board_id}'] .connectedSortable",
      stop: (event, ui)->
        # get the ticket data hash. We only need to know the new sattus and the ticket id
        data = deconstruct_ticket_html(ui.item[0])
        $(board).trigger("board:ticket:moved", data)
      })

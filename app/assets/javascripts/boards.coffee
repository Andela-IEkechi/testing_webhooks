# Boards
#-------

# Board tickets
#--------------
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
        place_ordered_ticket(column, ticket_html)

construct_ticket_html = (template, ticket)->
  ticket_html = $($('<textarea />').html(template).text())
  # we have to use attr here, using .data does not update the dom
  ticket_html.attr("data-id", ticket.id)
  ticket_html.attr("data-order", ticket.order)
  ticket_html.find(".id").html(ticket.id)
  ticket_html.find(".name").html(ticket.name)
  if ticket.board
    ticket_html.find(".board").html(ticket.board.name)
  else
    ticket_html.find(".board").html("")
  if ticket.assignee
    ticket_html.find(".assignee").html(ticket.assignee.email)
  else
    ticket_html.find(".assignee").html("")
  if ticket.status
    ticket_html.find(".status").html(ticket.status.name)
  else
    ticket_html.find(".status").html("")
  ticket_html.find(".cost").html(ticket.cost)

  return ticket_html[0].outerHTML

deconstruct_ticket_html = (ticket_html)->
  ticket = {}
  ticket.ticket_id = $(ticket_html).data("id")
  ticket.status_id = $(ticket_html).parents('[data-status-id]').data("status-id")
  ticket.order = $(ticket_html).index()
  ticket

place_ordered_ticket = (container, ticket_html)->
  # get our order
  order = parseInt($(ticket_html).data("order"))
  # check to see if there is a ticket we need to prepend outselves to, based on our order
  ticket_after = $(container).find(".ticket")[order] #dont look at the ticket's data-order, that could be stale
  if ticket_after
    $(ticket_after).before(ticket_html)
  else
    #otherwise just add us to the bottom of the container
    $(container).append(ticket_html)

$(document).on "click", ".boards-nav a.board-settings", (event)->
  event.preventDefault()
  active_board_id = $(this).parents('ul').find('.active').attr('href')
  $("#{active_board_id}").find('form').show()
  $("#{active_board_id}").find('table').hide()

$(document).on "board:ticket:create", ".board", (event, ticket)->
  #find the right board
  board = $(".board table[data-board-id=#{ticket.board_id}]")
  #construct a new ticket
  template = board.data("ticket-template")
  ticket_html = construct_ticket_html(template, ticket)
  #place it on the board
  column = $(board).find("td[data-status-id='#{ticket.status.id}']")
  place_ordered_ticket(column, ticket_html)

$(document).on "board:ticket:update", ".board", (event, ticket)->
  #find the right board
  board = $(".board[data-board-id=#{ticket.board.id}]")
  #find the ticket that was updated, and remove it from the board
  ticket_html = $(".board .ticket[data-id=#{ticket.id}]").remove()
  column = $(board).find("td[data-status-id='#{ticket.status.id}']")
  place_ordered_ticket(column, ticket_html)

$(document).on "board:ticket:destroy", ".board", (event, ticket)->
  $(".board .ticket[data-id=#{ticket.id}]").remove()

# we need to load this on a turbolinks event, so we can load boards when the project changes
$(document).on "turbolinks:load", ->
  for board in $(".board")
    fetch_board(board)
    board_id = $(board).data('board-id')
    $(board).find("table tbody tr td").sortable({
      connectWith: ".board[data-board-id='#{board_id}'] .connectedSortable",
      stop: (event, ui)->
        # get the ticket data hash. We only need to know the new sattus and the ticket id
        data = deconstruct_ticket_html(ui.item[0])
        $(board).trigger("board:ticket:moved", data)
      })



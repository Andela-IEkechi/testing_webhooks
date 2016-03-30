# Tickets
#---------

fetch_tickets = (tickets)->
  #get the url we need to pull the ticket info from
  tickets_url = $(tickets).data("tickets-url")
  $.ajax tickets_url,
    datatype: "json",
    method: "GET",
    success: (data)->
      # remove the placeholder row
      $(tickets).find("tbody tr").remove()
      template = $(tickets).data("ticket-template")
      for ticket in data
        ticket_html = construct_ticket_html(template, ticket)
        # insert the ticket html into the table
        column = $(tickets).find("tbody")
        column.append(ticket_html)

construct_ticket_html = (template, ticket)->
  ticket_html = $($('<textarea />').html(template).text())
  # we have to use attr here, using .data does not update the dom
  ticket_html.attr("data-id", ticket.id)
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

  ticket_html.find(".cost").attr("data-cost", ticket.cost)
  if ticket.cost == 0
    ticket_html.find(".cost").html("")
  else
    ticket_html.find(".cost").html(ticket.cost_key)

  ticket_html.find(".link").attr("href", ticket.edit_url)

  return ticket_html[0].outerHTML

$(document).on "project:ticket:create", ".tickets", (event, ticket)->
  #construct a new ticket
  template = $(this).data("ticket-template")
  ticket_html = construct_ticket_html(template, ticket)
  #place it on the project
  $(project).find("tbody").append(ticket_html)

$(document).on "project:ticket:update", ".tickets", (event, ticket)->
  #construct a new ticket
  template = $(this).data("ticket-template")
  #find the ticket that was updated, and replace
  ticket_html = construct_ticket_html(template, ticket)
  $(template).replace(ticket_html)

$(document).on "project:ticket:destroy", ".tickets", (event, ticket)->
  $(this).find(".ticket[data-id=#{ticket.id}]").remove()

# we need to load this on a turbolinks event, so we can load tickets when the project changes
$(document).on "turbolinks:load", ->
  if $(".tickets")
    fetch_tickets($(".tickets"))

context_name = ".ticket"
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


# we need to load this on a turbolinks event, so we can load tickets when the project changes
$(document).on "turbolinks:load", ->
  if $("#tickets table")
    fetch_tickets($("#tickets table"))

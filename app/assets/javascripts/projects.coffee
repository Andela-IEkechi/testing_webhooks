context_name = ".project"
context = (selector) ->
  if selector
    $(context_name).find(selector)
  else
    $(context_name)

#pick the correct tab
activate_tab = ()->
  #figure out where we are supposed to be
  if context("[data-active-tab]").length > 0
    wanted = context("[data-active-tab]").data("active-tab")
  else
    wanted = "#boards"
  context("a[href=\"#{wanted}\"]").tab("show")

adjustStatesSortableIndexes = ->
  # we need to update the input field that stores the relative order
  context("table tbody#ticket_statuses tr input[id$='order']").each (index, element) ->
    $(element).val(index)

$(document).on "DOMSubtreeModified", "#{context_name} table tbody#ticket_statuses", (event) ->
  adjustStatesSortableIndexes()

$(document).on "shown.bs.tab", "#{context_name} [id^='board-']", ->
  board_id = $(this).attr('id')
  App.board_tickets.retrieve(board_id)

$ ->
  activate_tab()

  context("table tbody#ticket_statuses").sortable()


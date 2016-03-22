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
  context("table tbody#statuses tr input[id$='order']").each (index, element) ->
    $(element).val(index)

$(document).on "DOMSubtreeModified", "#{context_name} table tbody#statuses", (event) ->
  adjustStatesSortableIndexes()

$ ->
  activate_tab()
  context("table tbody#statuses").sortable()

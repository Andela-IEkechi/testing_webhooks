#pick the correct tab
activate_tab = ()->
  #figure out where we are supposed to be
  if $(".project[data-active-tab]").length > 0
    wanted = $(".project[data-active-tab]").data("active-tab")
  else
    # default to showing the boards
    wanted = "#boards"
  $(".project").find("a[href=\"#{wanted}\"]").tab("show")

adjustStatesSortableIndexes = ->
  # we need to update the input field that stores the relative order
  $(".project table tbody#statuses tr input[id$='order']").each (index, element) ->
    $(element).val(index)

# re-sort statuses
$(document).on "DOMSubtreeModified", ".project table tbody#statuses", (event) ->
  adjustStatesSortableIndexes()

$ ->
  activate_tab()
  $(".project table tbody#statuses").sortable()


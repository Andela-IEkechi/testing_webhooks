# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("a.autoload").click()

  # Ask to confirm if one of the members will be revoked
  $(".members").submit ->
    values = (sel.value for sel in $('.members select'))
    if (values.indexOf("") > -1)
      if (!confirm("You are about to revoke the membership of some users. Are you sure?"))
        return false

  $("#sortable-statuses").sortable ->
    { placeholder: "well well-small alert alert-info" }

  $("#sortable-statuses").on "DOMSubtreeModified", (event) ->
    adjustStatesSortableIndexes()  if $(event.target).is("div#sortable-statuses")

  adjustStatesSortableIndexes = ->
    $("#sortable-statuses .ui-state-default [data-sort-index]").each (index, element) ->
      $(element).val index

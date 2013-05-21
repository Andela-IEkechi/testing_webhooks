# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  toggle_projects = ->
    if $('#overview_project_all').is(':checked')
      #toggle all the others and then disable them
      $('[name="overview[project_ids][]"]').prop('checked', true).prop('disabled', true)
    else
      #enable them
      $('[name="overview[project_ids][]"]').prop('disabled', false)

  $('#overview_project_all').change ->
    toggle_projects()

  toggle_projects()



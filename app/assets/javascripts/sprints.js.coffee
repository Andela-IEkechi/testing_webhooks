# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Function to change row colors
refresh_row_stripes = (table) ->
  $(table).find('tbody tr:visible').each (idx, tr) ->
    if idx % 2 == 0
      $(tr).addClass('even').removeClass('odd')
    else
      $(tr).addClass('odd').removeClass('even')

$ ->
  $('.datepicker').datepicker({format: 'yyyy-mm-dd'})

  $('#sprint-list tr[data-state="closed"]').hide()
  refresh_row_stripes($('#sprint-list'))


  $("#show_closed_sprints").change ->
    if this.checked
      $('#sprint-list tr[data-state="closed"]').show()
    else
      $('#sprint-list tr[data-state="closed"]').hide()

    refresh_row_stripes($('#sprint-list'))


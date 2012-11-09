# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $('.datepicker').datepicker({format: 'yyyy-mm-dd'})

  $('#sprint-list tr[data-state="closed"]').hide();

  $("#show_closed_sprints").change ->
    $('#sprint-list tr[data-state="closed"]').show() if this.checked
    $('#sprint-list tr[data-state="closed"]').hide() unless this.checked

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $('.datepicker').datepicker({format: 'yyyy-mm-dd'})

  $("#show-closed").toggle (->
    $(this).html "Hide Closed Sprints"
    $("#closed-sprints").toggle()
    ), ->
      $(this).html "Show Closed Sprints"
      $("#closed-sprints").toggle()
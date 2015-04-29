# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $('.datepicker').datepicker({format: 'yyyy-mm-dd'})

  $('#sprint-list tr[data-state="closed"]').hide();

  # Function to chnge row colors
  stripeOne = (myarray) ->
    myarray.each (yo, ho) =>
      if yo % 2 == 0 
        $(ho).find('td').css "background-color", "#f4f4f4"
      else
        $(ho).find('td').css "background-color", "#ffffff"

  # Change the row colors when the page loads
  tableLines = $('.sprint-table tbody tr[data-state="open"]')
  stripeOne(tableLines)

  # On
  $("#show_closed_sprints").change ->
    if this.checked
      $('#sprint-list tr[data-state="closed"]').show()
      tableLines = $('.sprint-table tbody tr')
      stripeOne(tableLines)

    if !this.checked
      $('#sprint-list tr[data-state="closed"]').hide()
      tableLines = $('.sprint-table tbody tr[data-state="open"]')
      stripeOne(tableLines)

    #removed as its in the top lines
    #$('#sprint-list tr[data-state="closed"]').show() if this.checked
    #$('#sprint-list tr[data-state="closed"]').hide() unless this.checked

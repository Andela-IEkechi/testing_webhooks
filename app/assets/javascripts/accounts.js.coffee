# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $('#account_change').click (event) ->
    checked_plan = $('input[name="Amount"]:checked')
    plan = checked_plan.attr('id').match(/amount_(.*)/)[1]
    $('input[name="ACCB_Amount"]').val(checked_plan.val())
    url = $('input[name="RedirectSuccessfulURL"]').val()
    $('input[name="RedirectSuccessfulURL"]').val(url + "&plan=" + plan)

  $('input[name="Amount"]').change ->
    $('input[name="Amount"]').parent().parent().parent().removeClass('price-column-featured')
    $(this).parent().parent().parent().addClass('price-column-featured')

  $('input[name="Amount"]:checked').parent().parent().parent().addClass('price-column-featured')

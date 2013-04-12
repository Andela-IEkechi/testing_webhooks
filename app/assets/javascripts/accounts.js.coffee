# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $('#account_change').click ->
    amount = $('input[name="Amount"]:selected').val()
    $('input[name="ACCB_Amount"]').val(amount)
    //update the success url to pass in the new plan
    url = $('input[name="RedirectSuccessfulURL"').val()
    plan = $('input[name="Amount"]:selected').attr('name').gsub(/amount_/,'')
    $('input[name="RedirectSuccessfulURL"').val(url + "&plan=" + plan)


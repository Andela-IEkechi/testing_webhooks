# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#checkout_form').hide()
  $('#downgrade_form').hide()

  $('input[name="Amount"][type="radio"]').change ->
    $("#checkout_form").before($(".notice_1").toggle($(this).data('upgrade')))
    $("#checkout_form").before($(".alert_1").toggle(!$(this).data('upgrade') && !$(this).data('downgrade')))
    $("#checkout_form").before($(".notice_2").toggle(!$(this).data('upgrade') && $(this).data('downgrade')))

    $('input[name="li_1_price"]').val($(this).val())
    $('#checkout_form').toggle($(this).data('upgrade'))
    $('#downgrade_form').toggle(!$(this).data('upgrade'))
    $('input[name="Amount"]').parent().parent().parent().removeClass('price-column-featured')
    $(this).parent().parent().parent().addClass('price-column-featured')
    $('input[name="li_1_name"]').val($(this).data('plan'))

  $('.price-column-featured input[name="Amount"][type="radio"]').attr('checked', true)

  $('input[name="Amount"][type="radio"]:checked').change()

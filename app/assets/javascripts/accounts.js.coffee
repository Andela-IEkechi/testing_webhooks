# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@toggle_button = (x) ->
  if x == true
    $('#account_change_cancel').removeAttr("disabled")
    $('#account_change_downgrade').removeAttr("disabled")
  else
    $('#account_change_cancel').attr("disabled", "disabled")
    $('#account_change_downgrade').attr("disabled", "disabled")
      
$ ->
  $('#checkout_form').hide()
  $('#downgrade_form').hide()
  $('#cancellation_form').hide()

  $('input[name="Amount"][type="radio"]').change ->
    toggle_button(!(!$(this).data('upgrade') && !$(this).data('downgrade')))

    $("#checkout_form").before($(".account_upgrade_notice").toggle($(this).data('upgrade')))
    $("#checkout_form").before($(".account_downgrade_notice").toggle(!$(this).data('upgrade') && $(this).data('downgrade')))
    $("#checkout_form").before($(".account_downgrade_alert").toggle(!$(this).data('upgrade') && !$(this).data('downgrade')))

    $('input[name="li_1_price"]').val($(this).val())

    $('#checkout_form').toggle($(this).data('upgrade') && !($(this).data('plan') == "Free"))
    $('#downgrade_form').toggle(!$(this).data('upgrade') && !($(this).data('plan') == "Free"))
    $('#cancellation_form').toggle(($(this).data('plan') == "Free"))

    $('input[name="Amount"]').parent().parent().parent().removeClass('price-column-featured')
    $(this).parent().parent().parent().addClass('price-column-featured')

    $('input[name="li_1_name"]').val($(this).data('plan'))
    
    $.ajax "/startup_fee",
      datatype: "json"
      method: "post"
      data: $('form#checkout_form').serialize()
      success: (data) ->
        $.map data, (value, key) ->
          $('input[name="'+key+'"]').val(value)

  $('.price-column-featured input[name="Amount"][type="radio"]').attr('checked', true)

  $('input[name="Amount"][type="radio"]:checked').change()
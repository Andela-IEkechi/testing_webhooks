# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#checkout_form').hide()
  $('#downgrade_form').hide()

  $('input[name="Amount"][type="radio"]').change ->
    $('input[name="li_1_price"]').val($(this).val())

    $('#checkout_form').toggle($(this).data('upgrade'))
    $('#downgrade_form').toggle(!$(this).data('upgrade'))

    $('input[name="Amount"]').parent().parent().parent().removeClass('price-column-featured')
    $(this).parent().parent().parent().addClass('price-column-featured')

    $('input[name="li_1_name"]').val($(this).data('plan'))
    
    $.ajax "/startup_fee",
      datatype: "json"
      method: "post"
      data: $('form#checkout_form').serialize()
      success: (data) ->
        $.map data, (value, key) ->
        # DON'T fuck with this!!! See note in accounts controller
          $('input[name="'+key+'"]').val(value)

  $('.price-column-featured input[name="Amount"][type="radio"]').attr('checked', true)

  $('input[name="Amount"][type="radio"]:checked').change()
$ ->

  $('#comment_preview_button').click ->
    fetch_preview()

  fetch_preview = ->
    output = $("#ticket_preview")
    output.html("Loading preview...")

    jQuery.ajax(
      url: "/comments/preview",
      # Not very elegant, but it works
      data: {"[comment][body]": $("textarea").first().val() },
      type: 'POST',
      dataType: 'json'
      success: (response) ->
          output.html(response.rendered_body)
    )

  $('.img').click ->
    if $(this).hasClass('img-large')
      $(this).attr('src', $(this).data('thumb-url')).removeClass('img-large')
    else
      $(this).attr('src', $(this).data('original-url')).addClass('img-large')
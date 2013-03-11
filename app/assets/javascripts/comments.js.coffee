$ ->
  if typeof _enable_preview isnt 'undefined'

    input  = jQuery("#comment_body")
    output = jQuery("#comment_preview")
    button = jQuery("#button_preview")

    button.on("click" : ->
      preview()
    )

    preview = () ->
      output.fadeOut('fast', () ->
        $.ajax(
          url: _comments_preview_url,
          data: $("#new_comment").serialize()
          type: 'POST'
          dataType: 'json'
          success: (response) ->
            output.html(response.rendered_content)
            output.fadeIn('fast')
        )
      )


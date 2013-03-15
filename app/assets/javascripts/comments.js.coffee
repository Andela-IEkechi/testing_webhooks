$ ->
  if typeof _enable_preview isnt 'undefined'

    input  = jQuery("#comment_body")
    output = jQuery("#comment_preview")
    button = jQuery("#button_preview")

    button.on("click" : ->
      preview()
    )

    preview = () ->
      jQuery.ajax(
        url: _comments_preview_url,
        data: input.parents('form').serialize()
        type: 'POST'
        dataType: 'json'
        success: (response) ->
          unless response.rendered_content is ""
            output.html(response.rendered_content)
          else
            output.html('There appears to be no comment content to preview. Type something first?')
          output.show()
      )


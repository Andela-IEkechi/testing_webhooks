$ ->
  if typeof _enable_preview isnt 'undefined'

    converter = new Markdown.Converter()

    input  = jQuery("#comment_body")
    output = jQuery("#comment_preview")
    button = jQuery("#button_preview")

    button.on("click" : ->
      toggle_preview()
      markdown = converter.makeHtml(input.val())
      output.html(markdown)
    )

    toggle_preview = () ->
      if input.css("display") is "none"
        output.fadeOut('fast', () ->
          input.fadeIn('fast')
        )
      else
        input.fadeOut('fast', () ->
          output.fadeIn('fast')
        )


context_name = ".document"
context = (selector) ->
  if selector
    $(context_name).find(selector)
  else
    $(context_name)

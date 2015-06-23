$(document).on 'submit', 'form[data-confirm-with]', (e) ->
  elementsToCheck = $(this).attr('data-confirm-input-selectors')
  mustConfirm = false

  $(this).find(elementsToCheck).each (index, element) ->
    if $(element).val() == '' or $(element).val() == null
      mustConfirm = true

  if mustConfirm and !confirm($(this).attr('data-confirm-with'))
    return false

$(document).on 'click', '[data-toggle]', (e) ->
  elementsToToggle = $(this).attr('data-toggle')
  if $(this).html() == $(this).attr('data-shown')
    $(elementsToToggle).hide()
    $(this).html $(this).attr('data-hidden')
  else
    $(elementsToToggle).show()
    $(this).html $(this).attr('data-shown')

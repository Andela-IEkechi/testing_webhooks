
# The selector for validation needs to be slightly different to the norm, since they apply to all forms
context_name = "form"
context = (selector) ->
  if selector
    $(context_name).find(selector)
  else
    $(context_name)

# NOTE: Pull valid options dynamically from the backend
prepare_allowed_fields = (input_field) ->
    # url = $(input_field).data('allowed-values-url') + '?query=%QUERY'
    # field_name = $(input_field).data('allowed-values-field')
    # values = new Bloodhound({
    #   remote: url,
    #   queryTokenizer: Bloodhound.tokenizers.whitespace,
    #   datumTokenizer: (d) ->
    #     # force string conversion, otherwise we get a js error on backspace
    #     Bloodhound.tokenizers.obj.whitespace(""+field_name)
    # })

    # values.initialize()

    # $(this).typeahead(
    #   {
    #     hint: true;
    #     highlight: true,
    #     minLength: 1
    #   },
    #   {
    #     name: 'Values',
    #     displayKey: (value)->
    #       # force string conversion, otherwise we get a js error on backspace
    #       return ""+value[field_name]
    #     source: values.ttAdapter()
    #   }
    # )

#disable items that require forms to be valid
$(document).on 'judge:validated', "#{context_name}", ->
  valid_form = $(this).find('.has-danger').length == 0
  for item in $(this).find('[data-requires-valid-form]')
    if valid_form
      $(item).removeAttr('disabled')
    else
      $(item).attr('disabled', 'disabled')

$(document).on 'focusout', "#{context_name} [data-validate]", ->
  # NOTE: If we use a ruby proc to set the exclusion values, Judge does not populate it, so we have to manually check for it
  # to make it work, you need to set a data-exclusion attribute on the input
  judge.eachValidators.exclusion = (options, messages) ->
    errorMessages = []
    if $(this).data('exclusion') && this.value in $(this).data('exclusion')
      errorMessages.push(messages.exclusion)
    new judge.Validation(errorMessages)

  judge.validate(this, {
    valid: (element) ->
      $(element).parents('.form-group').removeClass('has-danger')
      $(element).parents('.form-group').find("span").remove()
      $(element).parents('.form-group').addClass('has-success')
      $(element).removeClass('form-control-danger')
      $(element).addClass('form-control-success')
    invalid: (element, messages) ->
      $(element).parents('.form-group').removeClass('has-success')
      $(element).parents('.form-group').addClass('has-danger')
      $(element).parents('.form-group').find("span").remove() #clear out any existing messages
      $(element).parents('.form-group').append("<span class=\"text-help\">#{messages[0]}</span>")
      $(element).addClass('form-control-danger')
      $(element).removeClass('form-control-success')

  })
  $(this).parents('form').trigger("judge:validated")

# we sometimes have form controls that require other inputs to skip validations.
#eg, a radio button that renders a field required/optional
$(document).on 'focusout', "#{context_name} [data-skip-validate]", ->
  #clear out any existing validation status
  $(this).parents('.form-group').removeClass('has-danger')
  $(this).parents('.form-group').find("span").remove()
  $(this).removeClass('form-control-danger')
  $(this).removeClass('form-control-success')
  $(this).parents('form').trigger("judge:validated")

#mousing out of the disbursements table should validate all the inputs at once.
$(document).on "mouseover", "#{context_name} [data-requires-valid-form]", ->
  for input in $(this).parents('form').find('[data-validate]')
    $(input).trigger('focusout') #revalidate


$(document).on "cocoon:after-remove", "#{context_name}", ->
  context().trigger("judge:validated")

$ ->
  if context().length > 0
    for input in context('input[data-allowed-values-url]')
      prepare_allowed_fields(input)

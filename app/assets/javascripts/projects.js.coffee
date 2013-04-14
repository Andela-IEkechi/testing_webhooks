# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("a.autoload").click()

  # Ask to confirm if one of the memberships will be revoked
  $(".memberships").submit ->
    values = (sel.value for sel in $('.memberships select'))
    if (values.indexOf("") > -1)
      if (!confirm("You will revoke the membership of some users. You want to continue?"))
        return false


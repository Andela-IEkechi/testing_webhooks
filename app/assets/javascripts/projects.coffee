context_name = ".project"
context = (selector) ->
  if selector
    $(context_name).find(selector)
  else
    $(context_name)

#pick the correct tab
activate_tab = ()->
  #figure out where we are supposed to be
  if context("[data-active-tab]").length > 0
    wanted = context("[data-active-tab]").data("active-tab")
  else
    wanted = "#boards"
  context("a[href=\"#{wanted}\"]").tab("show")

$ ->
  console.log "project.coffee"
  activate_tab()

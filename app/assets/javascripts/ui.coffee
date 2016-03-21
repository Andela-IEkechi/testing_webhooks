# TODO: we need to repeat this ina  loop while the page is shown
window.setTimeout ->
  setTimeout ->
   $(".alert-dismissable").fadeTo(500, 0).slideUp(500, -> $(this.remove()))
  ,10000


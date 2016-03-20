
window.setTimeout ->
  setTimeout ->
   $(".alert-dismissable").fadeTo(500, 0).slideUp(500, -> $(this.remove()))
  ,10000


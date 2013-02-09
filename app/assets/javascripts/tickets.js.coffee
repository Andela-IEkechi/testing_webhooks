# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.clickable').click ->
    window.location = $(this).data('href');

  $('.repeat-action').click ->
    action = $(this).parentsUntil('form').parent().attr('action')
    action = action + '?create_another=true'
    $(this).parentsUntil('form').parent().attr('action', action)

  # pagination init - make [Prev] disabled and [1] active
  $('#pagination ul li').eq(0).addClass('disabled')
  $('#pagination ul li').eq(1).addClass('active')

  # pagination for [prev], [numbers] and [next]
  $('#pagination ul li a').click ->
    pagenum = parseInt($(this).text())
    num_pages = $('#pagination ul li a').length

    if isNaN(pagenum) # [Prev] and [Next]
      if $(this).text().match("Prev") and $('#pagination ul li.active').first().text() != "1"
        pagenum = parseInt($('#pagination ul li.active').first().text()) - 1
      else if $(this).text().match("Next") and $('#pagination ul li.active').first().text() != ("" + (num_pages - 2))
        pagenum = parseInt($('#pagination ul li.active').first().text()) + 1
      else
        return

    $('#all-comments').children().hide()   # hide all pages
    $('#comments-page-' + pagenum).show()  # show current page
    $('#pagination ul li').removeClass('disabled active')
    $('#pagination ul li').eq(pagenum).addClass('active')
    if (pagenum == 1)
        $('#pagination ul li').first().addClass('disabled')
    if (num_pages - pagenum == 2)
        $('#pagination ul li').last().addClass('disabled')

  # Show all comments
  $('#showAllBtn').click ->
    $('#pagination ul').hide()
    $('#showAllBtn').hide()
    $('#showPagesBtn').show()
    $('#all-comments').children().show()

  # Show in pages
  $('#showPagesBtn').click ->
    $('#pagination ul').show()
    $('#showAllBtn').show()
    $('#showPagesBtn').hide()
    $('#pagination ul li a').slice(1).first().click()
    window.scrollTo(0,0)


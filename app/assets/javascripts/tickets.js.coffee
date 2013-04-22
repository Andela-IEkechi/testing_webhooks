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

  $('a.show_older').click ->
    $('.older_comments').slideDown();
    $(this).hide();
    $('.hide_older').show();

  $('a.hide_older').click ->
    $('.older_comments').slideUp();
    $(this).hide();
    $('.show_older').show();



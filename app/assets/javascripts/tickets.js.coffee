# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.clickable').click ->
    window.location = $(this).data('href');

  $("#git-commands-toggle").click ->
    $('#git-commands').show();
    $('#git-commands-toggle').hide();

  $("#git-commands").click ->
    $('#git-commands-toggle').show();
    $('#git-commands').hide();

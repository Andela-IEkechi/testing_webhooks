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
  
  $("#git-commands code").click (event) ->
    event.stopPropagation();

  $(".ticket-filter #state-picker li").click ->
    choice = $(this).html();
    $('.ticket-filter tr[data-state="'+choice+'"]').show();
    $('.ticket-filter tr[data-state!="'+choice+'"]').hide();

  $(".ticket-filter #state-picker li:contains('All')").click ->
    $('.ticket-filter tr').show();

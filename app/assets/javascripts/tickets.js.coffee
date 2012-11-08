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



  $("#state-picker li").click ->
   # alert($(this).parent().prev().html());
    button = $(this).parent().prev();
    child = button.children();
    button.html($(this).html());
    button.append(child);

  $("#ticket-search").click ->
    choice = $('#state-picker').prev().text();
    $('tr[data-state="'+choice+'"]').show();
    $('tr[data-state!="'+choice+'"]').hide();

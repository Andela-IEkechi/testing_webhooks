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
    button = $(this).parent().prev();
    child = button.find();
    button.html($(this).html());
    button.append(child);
    choice = $(this).html();
    query = $("#search_input").val().toLowerCase();
    ticket_list_table = $(this).parentsUntil("#ticket-list").parent();
    if choice is 'All'
      ticket_list_table.find('tr').show();
      ticket_list_table.find('tr:not([data-search*="'+query+'"])').hide() if query;
    else
      ticket_list_table.find('tr[data-state="'+choice+'"]').show();
      ticket_list_table.find('tr[data-state!="'+choice+'"]').hide();
      ticket_list_table.find('tr:visible:not([data-search*="'+query+'"])').hide() if query;

  $(".ticket-filter #state-picker li:contains('All')").click ->
    $('.ticket-filter tr').show();



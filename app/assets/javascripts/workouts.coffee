# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


jQuery ->
  $('#workout_date').fdatepicker()

  if $("#run-index-table").length
    $("tr[data-link]").click ->
      window.location = $(this).data("link")

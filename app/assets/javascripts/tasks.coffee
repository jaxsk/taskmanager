# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# refresh task list every 10 second with ajax
setInterval (->
  $.ajax
    type: 'GET'
    url: '/refresh_activities'
  return
), 10000

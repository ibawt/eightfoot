# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery.ui.sortable

$(document).on 'page:load ready page:fetch', ->
  $("#sortable").sortable
    update: ->
      $.post("update_position", $(@).sortable('serialize'))

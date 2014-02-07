# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require jquery.ui.all

$(document).on 'page:load ready page:fetch', ->
  $('.column').sortable
    connectWith: '.column'
    handle: '.portlet-header'
    cancel: '.portlet-toggle'
    update: (e) ->
      $.post('update_position',$(e.target).sortable('serialize'))

    placeholder: 'portlet-placeholder ui-corner-all'

  # $('.portlet')
  #   .addClass('ui-widget ui-widget-content ui-helper-clearfix ui-corner-all')
  #   .find('.portlet-header')
  #     .addClass('ui-widget-header ui-corner-all')
  #     .prepend("<span class='ui-icon ui-icon-minusthick portlet-toggle'></span>")

  # $( ".portlet-toggle" ).click ->
  #   icon = $(@);
  #   icon.toggleClass( "ui-icon-minusthick ui-icon-plusthick" )
  #   icon.closest( ".portlet" ).find( ".portlet-content" ).toggle()

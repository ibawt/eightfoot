$(document).on 'page:load ready page:fetch', ->
  $('#milestone-selector').change ->
    window.location = "?milestone=#{encodeURI($(@).val())}"

  $('.gridster ul').gridster
    widget_margins: [5,5]
    widget_base_dimensions: [180,180]
    avoid_overlapped_widgets: true
    resize: { enabled: true }
    serialize_params: ($elem, coords) ->
      { id: $elem.id, coords: coords }
    draggable:
      handle: '.portlet-header, .portlet-header .issue-title'
      stop: (event,ui) ->
        data = $('.gridster ul').gridster().data('gridster').serialize()
        $.post('update_position', data)

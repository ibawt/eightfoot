$(document).on 'page:load ready page:fetch', ->
  $('.gridster ul').gridster
    widget_margins: [2,2]
    widget_base_dimensions: [140,120]
    avoid_overlapped_widgets: true
    resize: { enabled: true }
    draggable:
      stop: (event,ui) ->
        $.post('update_position', $('.gridster ul').serialize())

$(document).on 'page:load ready page:fetch', ->
  $('#milestone-selector').change ->
    window.location = "?milestone=#{encodeURI($(@).val())}"

  $('.gridster ul').gridster
    widget_margins: [2,2]
    widget_base_dimensions: [140,120]
    avoid_overlapped_widgets: true
    resize: { enabled: true }
    serialize_params: ($elem, coords) ->
      { id: $elem[0].id, coords: {
        col: coords.col,
        row: coords.row,
        size_x: coords.size_x,
        size_y: coords.size_y
        }
      }
    draggable:
      stop: (event,ui) ->
        data = issues: $('.gridster ul').gridster().data('gridster').serialize()
        $.post('update_position', data)

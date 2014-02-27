$(document).on 'page:load ready page:fetch', ->
  $('#milestone-selector').change ->
    window.location = "?milestone=#{encodeURI($(@).val())}"
    #$.post 'change_milestone', milestone: $(@).val()

  $('.gridster ul').gridster
    widget_margins: [5,5]
    widget_base_dimensions: [180,180]
    avoid_overlapped_widgets: true
    resize: { enabled: true }
    draggable:
      start: (event, ui) ->
        event.preventDefault()
        event.stopPropagation()
      stop: (event,ui) ->
        event.preventDefault()
        event.stopPropagation()
        $.post('update_position', $('.gridster ul').serialize())

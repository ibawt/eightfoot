$(document).on 'page:load ready page:fetch', ->
  $('#milestone-selector').change ->
    window.location = "?milestone=#{encodeURI($(@).val())}"

  $('.gridster ul').gridster
    widget_selector: '.portlet'
    widget_margins: [5,2]
    widget_base_dimensions: [250,70]
    avoid_overlapped_widgets: true
    resize: { enabled: false }
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
        $.post('update_position', data).done (data) ->
          if data.refresh
            location.reload()

  searchifyText = (str) ->
    str.toLowerCase().trim()

  localSearch = _.throttle (ev) ->
    value = searchifyText($(ev.currentTarget).val())
    portlets = $(".portlet") # may be able to memoize this outside if we're not adding new issues dynamically

    portlets.removeClass("no-match")
    for ele in portlets
      title = searchifyText($(ele).find(".issue-title").text().toLowerCase().trim())
      labels = searchifyText($(ele).data().labels)
      author = $(ele).find(".issue-assignee").data("username") || ""
      author = searchifyText(author)

      if title.indexOf(value) == -1 and labels.indexOf(value) == -1 and author.indexOf(value) == -1  # super simple, but works
        $(ele).addClass("no-match")
  , 100

  $("#local-filter").on 'keyup', localSearch

  $(".issue-label-container").on "click", (ev) ->
    $(ev.currentTarget).toggleClass("expanded")

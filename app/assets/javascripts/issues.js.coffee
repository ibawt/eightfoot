$(document).on 'page:load ready page:fetch', ->
  $('#milestone-selector').change ->
    window.location = "?milestone=#{encodeURI($(@).val())}"

  nColumns = $(".column-heading").length

  # attempt to fill the rows from the top-->bottom
  for i in [0..nColumns]
    column = $(".portlet[data-col='#{i}']")

    j = 1
    for row in column
      row.dataset.row = j
      j++

  $('.gridster ul').gridster
    widget_selector: '.portlet'
    widget_margins: [5,2]
    widget_base_dimensions: [250,70]
    avoid_overlapped_widgets: true
    autogrow_cols: true
    resize: { enabled: false }
    serialize_params: (elem, coords) ->
      { id: elem[0].id, row: coords.row, col: coords.col }

    draggable:
      stop: (event,ui) ->
        data = $('.gridster ul').gridster().data('gridster').serialize()
        data = _(data).reduce( (acc, val) ->
          acc[val.id] = { row: val.row, col: val.col }
          acc
        , {})

        $.post('update_position', issues: data).done (data) ->
          if data.refresh
            location.reload()

  localSearch = _.throttle (ev) ->
    value = Helpers.searchifyText($(ev.currentTarget).val())
    portlets = $(".portlet") # may be able to memoize this outside if we're not adding new issues dynamically

    portlets.removeClass("no-match")
    for ele in portlets
      title = Helpers.searchifyText($(ele).find(".issue-title").text().toLowerCase().trim())
      labels = Helpers.searchifyText($(ele).data().labels)
      author = $(ele).find(".issue-assignee").data("username") || ""
      author = Helpers.searchifyText(author)

      if title.indexOf(value) == -1 and labels.indexOf(value) == -1 and author.indexOf(value) == -1  # super simple, but works
        $(ele).addClass("no-match")
  , 100

  $("#local-filter").on 'keyup', localSearch

  $(".issue-label-container").on "click", (ev) ->
    $(ev.currentTarget).toggleClass("expanded")

  $("#labels-button").on 'click', (ev) ->
    $( ".issue-label-container" ).toggleClass("expanded")

  $( "#labels-legend" ).hide()

  # http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
  urlParams = null
  (window.onpopstate = ->
    pl     = /\+/g # Regex for replacing addition symbol with a space
    search = /([^&=]+)=?([^&]*)/g
    decode = (s) -> return decodeURIComponent(s.replace(pl, " "))
    query  = window.location.search.substring(1)

    urlParams = {}
    while (match = search.exec(query))
      urlParams[decode(match[1])] = decode(match[2])
  )()

  # remove repo label prefilters:
  $(".remove-label-button").on "click", (ev) ->
    $button = $(ev.currentTarget).parents(".label-badge").remove()

    labels = []
    for el in $(".label-badge .label-text")
      labels.push el.textContent

    labels = labels.join(",")

    urlParams["labels"] = labels

    window.location.search = "?" + $.param(urlParams)

  change_heading = (ev) ->
    col_number = ev.target.getAttribute('id').replace('col-header-', '')
    data = heading: { col_number: col_number, value: ev.target.value }
    $.post 'change_heading', data

  $( '.column-heading input').on('blur', change_heading).on('keydown', (ev) -> $(ev.target).blur() if ev.keyCode == 13)

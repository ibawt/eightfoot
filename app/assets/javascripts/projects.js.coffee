# =require jquery.ui.autocomplete
$(document).on 'page:load ready page:fetch', ->

  $("#repository_slug").on 'keyup', (ev) ->
    perform_repo_search(ev.currentTarget.value)

  perform_repo_search = (string) ->
    cache = {}
    $( "#repository_slug" ).autocomplete(
      minLength: 2,
      source: ( request, response ) ->
        term = request.term
        if ( term in cache )
          response( cache[ term ] )
        $.getJSON( "search_repos.json", request, ( data, status, xhr ) ->
          cache[ term ] = data
          response( data )
        )
    )

  searchifyText = (str) ->
    str.toLowerCase().trim()

  localSearch = _.throttle (ev) ->
    toFilter = $(ev.currentTarget).data("filter-for")
    filterTargets = $(".local-filterable[data-name='#{toFilter}'] li")

    search = searchifyText($(ev.currentTarget).val())

    filterTargets.removeClass("no-match")
    for ele in filterTargets
      $ele = $(ele)
      meta = $ele.data('meta')

      for value in meta
        matched = false
        if searchifyText(value).indexOf(search) >= 0
          matched = true

      $ele.addClass("no-match") if !matched
  , 100

  $(".local-filter").on 'keyup', localSearch

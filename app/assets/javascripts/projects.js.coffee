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

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

  $(document).off 'click', '.user-add-button'
  $(document).on 'click', ".user-add-button", (ev) ->
    username = $(ev.target).data("username")
    $.post(add_path, {
      username: username
    }).done (data) ->
      $(ev.target).removeClass("user-add-button fa-plus-square").addClass("fa-minus-square user-remove-button toggling")

  $(document).off 'click', '.user-remove-button'
  $(document).on 'click', ".user-remove-button", (ev) ->
    username = $(ev.target).data("username")
    $.post(remove_path, {
      username: username
    }).done (data) ->
      $clicked = $(ev.target)
      if !$clicked.hasClass("toggling")
        $clicked.parents(".user-tile").remove()
      else
        $clicked.removeClass("fa-minus-square user-remove-button").addClass("user-add-button fa-plus-square")

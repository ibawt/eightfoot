window.Helpers = {}

Helpers.searchifyText = (str) ->
  str.toLowerCase().trim()

Helpers.localSearch = _.throttle (ev) ->
  toFilter = $(ev.currentTarget).data("filter-for")
  filterTargets = $(".local-filterable[data-filtered-by='#{toFilter}'] li")

  search = Helpers.searchifyText($(ev.currentTarget).val())

  filterTargets.removeClass("no-match")
  for ele in filterTargets
    $ele = $(ele)
    meta = $ele.data('meta')

    for value in meta
      matched = false
      if Helpers.searchifyText(value).indexOf(search) >= 0
        matched = true
        break

    $ele.addClass("no-match") if !matched
, 100

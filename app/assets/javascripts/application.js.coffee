#= require jquery
#= require jquery_ujs
#= require underscore
#= require turbolinks
#= require_tree .
#= require helpers.js.coffee
#= require bootstrap
#= require_tree ../../../vendor/assets/javascripts

# $(document).ready ->
#   setTimeout ->
#     source = new EventSource('/updates')
#     source.onmessage = (e) ->
#   , 1


$(document).ready ->
  $(document).on 'keyup', ".local-filter", Helpers.localSearch

#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require ./app

$ ->
  window.refreshes = window.pusher.subscribe('refreshes')

setup = ->
  $('#app').each -> new window.App

$(document).on 'page:load', setup
$ setup

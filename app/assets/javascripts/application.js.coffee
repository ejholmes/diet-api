#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require ./app

$ ->
  $('#app').each ->
    window.app = app = new window.App
    app.items.fetch()
    app.feeds.fetch()

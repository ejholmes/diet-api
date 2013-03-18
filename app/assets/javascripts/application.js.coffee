#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require ./app

setup = ->
  $('#sidebar').css 'min-height', document.height
  $('#app').each -> new window.App

$(document).on 'page:load', setup
$ setup

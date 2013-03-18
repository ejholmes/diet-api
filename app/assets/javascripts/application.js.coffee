#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require ./app

$ ->
  $('#sidebar').css 'min-height', document.height

  $('#app').each -> new window.App

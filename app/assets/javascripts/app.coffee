#= require underscore
#= require backbone

class Item extends Backbone.Model
  # Mark as read
  read: ->
    return if @get('read')
    @set('read', true)
    $.ajax "/items/#{@get('id')}/read", type: 'PUT'

  # Mark as unread
  unread: ->
    return unless @get('read')
    @set('read', false)
    $.ajax "/items/#{@get('id')}/read", type: 'DELETE'

class Feed extends Backbone.Model
  @subscribe: (url, callback) ->
    $.ajax "/user/subscriptions?url=#{url}",
      type: 'POST'
      success: callback

class ItemView extends Backbone.View
  events:
    'click' : 'toggle'

  initialize: ->
    @model = new Item(@$el.data('model'))
    @listenTo @model, 'change:read', @setStatus

  toggle: ->
    @model.read()
    @$el.toggleClass('active')

  setStatus: ->
    @$el.toggleClass('read', @model.get('read'))
    @$el.toggleClass('unread', !@model.get('read'))

class ItemsView extends Backbone.View
  el: 'ul#items'

  initialize: ->
    @$('li.item').each -> new ItemView(el: this)

class SubscribeView extends Backbone.View
  el: '#subscribe'

  events:
    'click' : 'click'

  initialize: ->
    _.bindAll this, 'click'

    @$button = @$('a')
    @$input  = @$('input:text')

    @$button.on 'click', @click
    @$input.on 'keypress', (e) =>
      code = e.keyCode || e.which
      @subscribe() if code == 13

  click: (e) ->
    e.preventDefault()
    @$el.addClass('subscribing')

  subscribe: ->
    Feed.subscribe @$input.val(), -> Turbolinks.visit(window.location)

class @App extends Backbone.View
  initialize: ->
    @views =
      items: new ItemsView
      subscribe: new SubscribeView

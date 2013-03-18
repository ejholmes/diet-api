#= require underscore
#= require backbone

class Item extends Backbone.Model
  defaults:
    'active': false

  toggleActive: ->
    @set('active', !@get('active'))

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
    $.ajax "/user/subscriptions?url=#{url}", type: 'POST', success: callback

class FeedsCollection extends Backbone.Collection
  model: Feed
  url: '/user/subscriptions'

class ItemsCollection extends Backbone.Collection
  model: Item
  url: '/items'

class ItemView extends Backbone.View
  tagName: 'li'
  className: 'item'
  template: """
  <span class="title"><%= feed.title %> &raquo; <%= title %></span>
  <div class="description"><%= description %></div>
  """

  events:
    'click' : 'toggle'

  initialize: ->
    @listenTo @model, 'change:read', @setStatus
    @listenTo @model, 'change:active', @display
    @id = "item-#{@model.get('id')}"

  render: ->
    @$el.attr id: @id
    @$el.html _.template(@template)(@model.toJSON())
    @model.trigger('change:read')
    this

  toggle: ->
    _.each @collection.models, (item) => item.set('active', false) unless item == @model
    @model.read()
    @model.toggleActive()

  display: ->
    @$el.toggleClass('active', @model.get('active'))
    window.location.hash = "##{@id}" if @model.get('active')

  setStatus: ->
    @$el.toggleClass('read', @model.get('read'))
    @$el.toggleClass('unread', !@model.get('read'))

class FeedView extends Backbone.View
  tagName: 'li'
  className: 'feed'
  template: """
  <a href="#"><%= title %> <span class="badge badge-info"><%= unread_count %></a>
  """

  render: ->
    @$el.html _.template(@template)(@model.toJSON())
    this

class ItemsView extends Backbone.View
  el: '#items'

  initialize: ->
    _.bindAll this, 'addOne'
    @listenTo @collection, 'reset', @render

  addOne: (item) ->
    view = new ItemView(model: item, collection: @collection)
    @$el.append(view.render().$el)

  render: ->
    _.each @collection.models, @addOne

class FeedsView extends Backbone.View
  el: '#feeds'

  initialize: ->
    _.bindAll this, 'addOne'
    @listenTo @collection, 'reset', @render

  addOne: (feed) ->
    view = new FeedView(model: feed, collection: @collection)
    @$el.append(view.render().$el)

  render: ->
    _.each @collection.models, @addOne
    $('#sidebar').height($('#main').height())

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
    Feed.subscribe @$input.val(), =>
      @el.removeClass('subscribing')

class @App extends Backbone.View
  el: '#app'

  initialize: ->
    @items = new ItemsCollection
    @feeds = new FeedsCollection
    @views =
      items: new ItemsView(collection: @items)
      feeds: new FeedsView(collection: @feeds)
    @subscribe = new SubscribeView

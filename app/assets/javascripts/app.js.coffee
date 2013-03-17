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
    $.ajax "/items/#{@get('id')}/read",
      type: 'PUT'

  # Mark as unread
  unread: ->
    return unless @get('read')
    @set('read', false)
    $.ajax "/items/#{@get('id')}/read",
      type: 'DELETE'

class Feed extends Backbone.Model

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
  <span class="title"><%= title %></span>
  <div class="description"><%= description %></div>
  """

  events:
    'click' : 'toggle'

  initialize: ->
    @listenTo @model, 'change:read', @setStatus
    @listenTo @model, 'change:active', @display

  render: ->
    @$el.html(_.template(@template)(@model.toJSON()))
    @model.trigger('change:read')
    this

  toggle: ->
    _.each @collection.models, (item) => item.set('active', false) unless item == @model
    @model.read()
    @model.toggleActive()

  display: ->
    @$el.toggleClass('active', @model.get('active'))

  setStatus: ->
    @$el.toggleClass('read', @model.get('read'))
    @$el.toggleClass('unread', !@model.get('read'))

class ItemsView extends Backbone.View
  el: '#items'

  initialize: ->
    @listenTo @collection, 'reset', @render

  render: ->
    _.each @collection.models, (item) =>
      view = new ItemView(model: item, collection: @collection)
      @$el.append(view.render().$el)

class FeedsView extends Backbone.View
  el: '#feeds'

  initialize: ->
    @listenTo @collection, 'reset', @render

  render: ->

class @App extends Backbone.View
  el: '#app'

  initialize: ->
    @items = new ItemsCollection
    @feeds = new FeedsCollection
    @views =
      items: new ItemsView(collection: @items)
      feeds: new FeedsView(collection: @feeds)

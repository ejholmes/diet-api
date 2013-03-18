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
    $.ajax "/user/subscriptions?url=#{url}",
      type: 'POST'
      success: callback

class ItemView extends Backbone.View
  events:
    'click .title' : 'toggle'

  initialize: ->
    @listenTo @model, 'change:read', @setStatus
    @listenTo @model, 'change:active', =>
      if @model.get('active') then @show() else @hide()

  toggle: ->
    @model.read()
    @model.toggleActive()

  show: ->
    @$el.addClass('active')
    window.location.hash = @$el.attr('id')
    @$('.description').html(@model.get('description'))

  hide: ->
    @$el.removeClass('active')

  setStatus: ->
    @$el.toggleClass('read', @model.get('read'))
    @$el.toggleClass('unread', !@model.get('read'))

class ItemsView extends Backbone.View
  el: 'ul#items'

  initialize: ->
    @$('li.item').each ->
      model = new Item($(this).data('model'))
      new ItemView(el: this, model: model)

class FeedView extends Backbone.View
  badge: """
  <span class="badge badge-info"></span>
  """
  initialize: ->
    window.refreshes.bind 'refresh', (data) =>
      Turbolinks.visit(window.location) if data.feed_id = @model.get('id')

    @$count = $('<span class="badge badge-info" />')
    @$el.append(@$count)

    @listenTo @model, 'change:unread_count', @update
    @model.trigger('change:unread_count')

  update: ->
    count = @model.get('unread_count')
    @$count.html(count) if count

class FeedsView extends Backbone.View
  el: 'ul#feeds'

  initialize: ->
    collection = @collection
    @$('li.feed').each ->
      model = new Feed($(this).data('model'))
      collection.add(model)
      new FeedView(el: this, model: model)

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
    @$input.focus()

  subscribe: ->
    Feed.subscribe @$input.val(), -> Turbolinks.visit(window.location)

class @App extends Backbone.View
  initialize: ->
    @items = new Backbone.Collection
    @feeds = new Backbone.Collection
    @views =
      items: new ItemsView(collection: @items)
      feeds: new FeedsView(collection: @feeds)
      subscribe: new SubscribeView

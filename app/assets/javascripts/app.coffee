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
    @model = new Item(@$el.data('model'))
    @listenTo @model, 'change:read', @setStatus
    @listenTo @model, 'change:active', @display

  toggle: ->
    @model.read()
    @model.toggleActive()

  display: ->
    @$el.toggleClass('active', @model.get('active'))
    window.location.hash = @$el.attr('id') if @model.get('active')

  setStatus: ->
    @$el.toggleClass('read', @model.get('read'))
    @$el.toggleClass('unread', !@model.get('read'))

class ItemsView extends Backbone.View
  el: 'ul#items'

  initialize: ->
    @$('li.item').each -> new ItemView(el: this)

class FeedView extends Backbone.View
  badge: """
  <span class="badge badge-info"></span>
  """
  initialize: ->
    @model = new Feed(@$el.data('model'))

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
    @$('li.feed').each -> new FeedView(el: this)

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
    @views =
      items: new ItemsView
      feeds: new FeedsView
      subscribe: new SubscribeView

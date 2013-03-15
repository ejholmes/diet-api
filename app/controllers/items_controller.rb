class ItemsController < ApplicationController
  respond_to :html, :json

  def index
    @items = Item.all
    @subscriptions = Feed.all
    respond_with @items
  end
end

class ItemsController < ApplicationController
  respond_to :html, :json

  def index
    @items = Item.includes(:feed).all
    @subscriptions = Feed.all
    respond_with @items
  end

  def read
    @item = Item.find(params[:id])
    @item.read!
    redirect_to @item.link
  end

  def refresh
    Feed.all.map(&:update)
    redirect_to root_path
  end
end

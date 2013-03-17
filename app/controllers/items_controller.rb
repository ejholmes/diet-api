class ItemsController < ApplicationController
  respond_to :html, only: :index
  respond_to :json

  def index
    @items = Item.includes(:feed).all
    respond_with @items
  end

  def read
    item.read!
    respond_with item
  end

  def unread
    item.unread!
    respond_with item
  end

private

  def item
    @item ||= Item.find(params[:id])
  end

end

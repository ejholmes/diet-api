class ItemsController < ApplicationController
  respond_to :html, only: :index
  respond_to :json

  def index
    @items = items.all
    respond_with items
  end

  def all_read
    items.read!
    render nothing: true, status: 200
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

  def items
    @items ||= Item.includes(:feed)
  end

  def item
    @item ||= Item.find(params[:id])
  end

end

class ItemsController < ApplicationController
  respond_to :html, only: :index
  respond_to :json

  def index
    if feed_id = params[:feed_id]
      @items = items.where(feed_id: feed_id)
    elsif unread = params[:unread]
      @items = items.where(read: false)
    else
      @items = items.all
    end
    @feeds = Feed.all
    respond_with items
  end

  def all_read
    items.read!
    respond_to do |format|
      format.json { render nothing: true, status: 200 }
      format.html { redirect_to items_path }
    end
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

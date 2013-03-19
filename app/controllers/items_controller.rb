class ItemsController < ApplicationController
  respond_to :html, only: :index
  respond_to :json

  before_filter :authenticate_user!

  def index
    @items = items.filtered(params).page params[:page]
    @feed = current_user.feeds.find(params[:feed_id]) if params[:feed_id]
    @feeds = current_user.feeds.all
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
    @items ||= current_user.items.includes(:feed)
  end

  def item
    @item ||= current_user.items.find(params[:id])
  end

end

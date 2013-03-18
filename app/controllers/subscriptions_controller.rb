class SubscriptionsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def index
    @subscriptions = current_user.feeds.all
    respond_with @subscriptions
  end

  def subscribe
    @subscription = current_user.subscribe_to(params[:url])
    respond_to do |format|
      format.json { render json: @subscription, status: 201 }
    end
  end

  def unsubscribe
    @subscription = current_user.feeds.find(params[:id])
    @subscription.destroy
    respond_with @subscription do |format|
      format.html { redirect_to items_path }
    end
  end
end

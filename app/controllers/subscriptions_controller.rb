class SubscriptionsController < ApplicationController
  respond_to :json

  def index
    @subscriptions = Feed.all
    respond_with @subscriptions
  end

  def subscribe
    @subscription = current_user.subscribe_to(params[:url])
    respond_to do |format|
      format.json { render json: @subscription, status: 201 }
    end
  end

  def unsubscribe
    @subscription = Feed.find(params[:id])
    @subscription.destroy
    respond_with @subscription
  end
end

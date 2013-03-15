class SubscriptionsController < ApplicationController
  respond_to :html, :json

  def subscribe
    Subscription.subscribe_to(params[:url]).update
    redirect_to root_path
  end
end

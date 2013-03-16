class SubscriptionsController < ApplicationController
  respond_to :html, :json

  def subscribe
    current_user.subscribe_to(params[:url]).refresh!
    redirect_to root_path
  end
end

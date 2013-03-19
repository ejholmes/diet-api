require_relative './environment'

class API < Grape::API
  version 'v1', using: :header, vendor: 'reader'
  format :json

  helpers do
    def current_user
      @current_user ||= User.new
    end

    def feeds
      Feed
    end
  end

  resource :subscriptions do
    desc 'Lists the authenticated users subscriptions.'
    get do
      feeds.all
    end

    desc 'Subscribe to a new feed.'
    params do
      requires :url, type: String, desc: 'URL to an RSS or Atom feed.'
    end
    post do
      current_user.subscribe_to(params[:url])
    end
  end
end

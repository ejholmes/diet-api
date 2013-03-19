require_relative './environment'

class API < Grape::API
  version 'v1', using: :header, vendor: 'reader'
  format :json

  resource :items do
    desc 'Lists all items.'
    get do
      Item.all
    end

    desc 'Lists only unread items.'
    get :unread do
      Item.unread.all
    end
  end

  resource :subscriptions do
    desc 'Lists the authenticated users subscriptions.'
    get do
      Feed.all
    end

    desc 'Subscribe to a new feed.'
    params do
      requires :url, type: String, desc: 'URL to an RSS or Atom feed.'
    end
    post do
      Subscriptions.new(params[:url]).subscribe
    end
  end
end

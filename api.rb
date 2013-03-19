require_relative './environment'

class API < Grape::API
  version 'v1', using: :header, vendor: 'reader'
  format :json

  helpers do
    def feed
      feeds.find(params[:id])
    end

    def feeds
      Feed.scoped
    end

    def item
      items.find(params[:id])
    end

    def items
      Item.scoped
    end
  end

  resource :items do
    desc 'Lists all items.'
    get do
      present items
    end

    desc 'Lists only unread items.'
    get :unread do
      present items.unread
    end

    desc 'Mark an item as read.'
    params do
      requires :id, type: String, desc: "Item id."
    end
    put ':id/read' do
      item.read!
      present item
    end

    desc 'Mark an item as unread.'
    params do
      requires :id, type: String, desc: "Item id."
    end
    put ':id/unread' do
      item.unread!
      present item
    end
  end

  resource :subscriptions do
    desc 'Lists the authenticated users subscriptions.'
    get do
      present feeds
    end

    desc 'Subscribe to a new feed.'
    params do
      requires :url, type: String, desc: 'URL to an RSS or Atom feed.'
    end
    post do
      present Subscription.new(params[:url]).subscribe
    end

    desc 'Unsubscribe from a feed.'
    params do
      requires :id, type: String, desc: 'Id of the subscription.'
    end
    delete ':id' do
      feed.destroy
    end
  end
end

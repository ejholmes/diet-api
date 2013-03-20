class API < Grape::API
  logger Logger.new(STDOUT)

  version 'v1', using: :header, vendor: 'reader'
  format :json

  helpers do
    def feed
      feeds.find(params[:id])
    end

    def feeds
      current_user.feeds.includes(:items).order('title ASC')
    end

    def item
      items.find(params[:id])
    end

    def items
      current_user.items.includes(:feed).order('created_at DESC')
    end

    def filtered_items
      items.filtered(params).paginate(page: params[:page])
    end

    def current_user
      @user ||= User.authenticate(params[:apikey])
    end

    def authenticate!
      unless ENV['RACK_ENV'] == 'test'
        error!('401 Unauthorized', 401) unless current_user
      end
    end
  end

  resource :items do
    desc 'Lists all items.'
    params do
      optional :subscription, type: String, desc: 'Subscription id to scope to.'
      optional :page, type: Integer, desc: 'Page to return. Defaults to first page.'
    end
    get do
      authenticate!
      present filtered_items
    end

    desc 'Lists all unread items.'
    params do
      optional :subscription, type: String, desc: 'Subscription id to scope to.'
      optional :page, type: Integer, desc: 'Page to return. Defaults to first page.'
    end
    get :unread do
      authenticate!
      present filtered_items.unread
    end

    desc 'Mark all items as read.'
    put :read do
      authenticate!
      items.read!
    end

    desc 'Return a specifiy item.'
    params do
      requires :id, type: String, desc: 'Item id.'
    end
    get ':id' do
      authenticate!
      present item, type: :full
    end

    desc 'Mark an item as read.'
    params do
      requires :id, type: String, desc: 'Item id.'
    end
    put ':id/read' do
      authenticate!
      item.read!
      present item
    end

    desc 'Mark an item as unread.'
    params do
      requires :id, type: String, desc: 'Item id.'
    end
    put ':id/unread' do
      authenticate!
      item.unread!
      present item
    end
  end

  resource :subscriptions do
    desc 'Lists the authenticated users subscriptions.'
    get do
      authenticate!
      present feeds
    end

    desc 'Subscribe to a new feed.'
    params do
      requires :url, type: String, desc: 'URL to an RSS or Atom feed.'
    end
    post do
      authenticate!
      present current_user.subscribe_to(params[:url])
    end

    desc 'Unsubscribe from a feed.'
    params do
      requires :id, type: String, desc: 'Id of the subscription.'
    end
    delete ':id' do
      authenticate!
      feed.destroy
    end
  end

  namespace :import do
    desc 'Import google reader subscriptions (exported via google takeout).'
    params do
      requires :file
    end
    post :google_reader do
      authenticate!
      Importer::GoogleReader.new(params.file.tempfile.read, user: current_user).import
      'Ok'
    end
  end

  namespace :users do
    desc 'Signup for an account. Returns the user, which contains an api key to authorize requests.'
    params do
      requires :email, type: String, desc: 'Your email.'
    end
    post do
      user = User.new(params)
      if user.save
        present user
      else
        status 400
        { error: user.errors }
      end
    end
  end
end

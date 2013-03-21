class API < Grape::API
  logger Logger.new(STDOUT)

  version 'v1', using: :header, vendor: 'reader'
  format :json

  helpers do
    def feed
      feeds.find(params.id)
    end

    def feeds
      current_user.feeds.includes(:items).order('title ASC')
    end

    def item
      items.find(params.id)
    end

    def items
      current_user.items.includes(:feed).order('created_at DESC')
    end

    def filtered_items
      items.filtered(params).paginate(page: params.page)
    end

    def session; env['rack.session'] end
    def warden; env['warden'] end

    def current_user
      warden.user
    end

    def current_user=(user)
      warden.set_user(user, store: false)
    end

    def authenticate!
      warden.authenticate!
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
    params do
      optional :ids, type: Array[String], desc: 'List of ids to mark as read.'
    end
    put :read do
      authenticate!
      { total: (params.ids.present? ? items.unread.where(id: params.ids) : items.unread).read! }
    end

    desc 'Return a specific item.'
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
    desc 'Lists subscriptions.'
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
      present current_user.subscribe_to(params.url)
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
      present Importer::GoogleReader.new(params.file.tempfile.read, user: current_user).import
    end
  end

  namespace :users do
    desc 'Create a new user account.'
    params do
      requires :email, type: String, desc: 'Your email.'
      requires :password, type: String, desc: 'Your password.'
    end
    post do
      user = User.new(declared(params))
      if user.save
        present user
      else
        error!(user.errors, 400)
      end
    end
  end

  namespace :user do
    namespace :readability do
      desc 'Enable posting to readability.'
      put do
        authenticate!
        if current_user.readability.authorized?
          current_user.readability.enable
          current_user.save!
          present current_user
        else
          error!('You need to authorize readability first.', 400)
        end
      end

      desc 'Disable posting to readability.'
      delete do
        authenticate!
        current_user.readability.disable
        current_user.save!
        present current_user
      end

      desc 'Authorize this account to post bookmarks to readability.'
      get :authorize do
        authenticate!
        session[:user_id] = current_user.id
        redirect '/auth/readability'
      end
    end
  end

  get '/auth/readability/callback' do
    current_user = User.find(session.delete(:user_id))
    auth_hash = request.env['omniauth.auth']
    current_user.readability.token = auth_hash.credentials.token
    current_user.readability.secret = auth_hash.credentials.secret
    current_user.save
    'Ok'
  end

  get '/auth/failure' do
    { error: "Authorization failed: #{params.message}" }
  end
end

Reader::Application.routes.draw do
  devise_for :users

  # Items
  resources :items do
    collection do
      get :unread, to: 'items#index', as: :unread, defaults: { unread: 1 }
      put :read, to: 'items#all_read', as: :read_all
    end

    member do
      put :read
      delete :read, to: 'items#unread', as: :unread
    end
  end

  # Subscriptions
  get '/user/subscriptions', to: 'subscriptions#index', as: :subscriptions
  post '/user/subscriptions', to: 'subscriptions#subscribe', as: :subscribe
  delete '/user/subscriptions/:id', to: 'subscriptions#unsubscribe', as: :unsubscribe

  root to: 'items#index'
end

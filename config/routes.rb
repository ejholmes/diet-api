Reader::Application.routes.draw do
  # Items
  resources :items do
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

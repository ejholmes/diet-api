Reader::Application.routes.draw do
  # Items
  resources :items do
    member do
      get :read
      get :unread
    end
  end

  # Subscriptions
  post '/subscribe', to: 'subscriptions#subscribe', as: :subscribe
  delete '/unsubscribe', to: 'subscriptions#unsubscribe', as: :unsubscribe

  root to: 'items#index'
end

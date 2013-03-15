Reader::Application.routes.draw do
  # Items
  get '/refresh', to: 'items#refresh'
  get '/read/:id', to: 'items#read', as: :read

  # Subscriptions
  post '/subscribe', to: 'subscriptions#subscribe', as: :subscribe
  delete '/unsubscribe', to: 'subscriptions#unsubscribe', as: :unsubscribe

  root to: 'items#index'
end

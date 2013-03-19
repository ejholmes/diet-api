require_relative './environment'
require_relative './app/models'

class App < Sinatra::Base
  helpers do
    def current_user
      @current_user ||= User.new
    end
  end

  get '/subscriptions' do
    content_type :json
    @subscriptions = Feed.all
    @subscriptions.to_json
  end

  post '/subscriptions' do
  end

  delete '/subscriptions/:id' do
  end
end

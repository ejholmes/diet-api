require 'i18n'
require 'active_support'
require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']
require 'grape'
require 'uri'

ActiveSupport.on_load :active_record do
  require 'will_paginate/active_record'
end

require 'active_record'

autoload :User,           'diet/models/user'
autoload :Item,           'diet/models/item'
autoload :Feed,           'diet/models/feed'
autoload :Subscription,   'diet/models/subscription'
autoload :EntryProcessor, 'diet/models/entry_processor'

module Authenticator
  autoload :Base,             'diet/models/authenticator/base'
  autoload :UsernamePassword, 'diet/models/authenticator/username_password'
end

module Importer
  autoload :Base,         'diet/models/importer/base'
  autoload :GoogleReader, 'diet/models/importer/google_reader'
end

module Diet
  autoload :Updater, 'diet/updater'

  module Middleware
    autoload :CORS, 'diet/middleware/cors'
  end

  module API
    autoload :App, 'diet/api/app'

    class << self
      def app
        @app ||= Rack::Builder.new do
          use Diet::Middleware::CORS

          use Rack::Session::Cookie, key: '_diet_session',
            domain: ENV['COOKIE_DOMAIN'],
            secret: ENV['COOKIE_SECRET'] || 'iebie5oKneequ1Ae'

          use Warden::Manager do |manager|
            manager.default_strategies :basic
            manager.failure_app = lambda { |env|
              [
                401,
                {
                  'Content-Type' => 'application/json',
                  'WWW-Authenticate' => %(Basic realm="API Authentication")
                },
                [{ error: '401 Unauthorized'}.to_json]
              ]
            }

            def unauthorized
            end
          end

          use OmniAuth::Builder do
            provider :readability, ENV['READABILITY_KEY'], ENV['READABILITY_SECRET']
          end

          run Diet::API::App
        end
      end
    end
  end

  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def setup(env = nil)
      ActiveRecord::Base.establish_connection(database_config(env))

      Readit::Config.consumer_key = ENV['READABILITY_KEY']
      Readit::Config.consumer_secret = ENV['READABILITY_SECRET']

      Warden::Strategies.add(:basic) do
        def auth
          @auth ||= Rack::Auth::Basic::Request.new(env)
        end

        def authenticate!
          return fail! unless auth.provided?
          return fail!(:bad_request) unless auth.basic?
          username, password = auth.credentials
          user = Authenticator::UsernamePassword.new(username, password).authenticate!
          user.nil? ? fail! : success!(user)
        end
      end

      Warden::Manager.serialize_into_session do |user|
        user.id
      end

      Warden::Manager.serialize_from_session do |id|
        User.find(id)
      end
    end

    def database_config(env = nil)
      env ||= ENV
      @database_config ||= begin
        database = URI(env['DATABASE_URL'] || "postgresql://localhost:5432/diet_api_#{env['RACK_ENV']}")
        { adapter: 'postgresql',
          pool: 5,
          database: database.path[1..-1],
          username: database.user,
          password: database.password,
          host: database.host,
          port: database.port }.with_indifferent_access
      end
    end
  end
end

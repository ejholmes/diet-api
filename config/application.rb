$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

require 'i18n'
require 'active_support'

ActiveSupport.on_load :active_record do
  require 'will_paginate/active_record'
end

Bundler.require :default, ENV['RACK_ENV']

require 'uri'
require 'grape'
require 'active_record'

def database_config
  @database_config ||= begin
    database = URI(ENV['DATABASE_URL'] || 'postgres://localhost:5432/reader_development')
    { adapter: 'postgresql',
      pool: 5,
      database: database.path[1..-1],
      username: database.user,
      password: database.password,
      host: database.host,
      port: database.port }.with_indifferent_access
  end
end

ActiveRecord::Base.establish_connection(database_config)

Readit::Config.consumer_key = ENV['READABILITY_KEY']
Readit::Config.consumer_secret = ENV['READABILITY_SECRET']

require 'api'
require 'app'

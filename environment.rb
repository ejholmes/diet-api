require 'i18n'
require 'active_support'

ActiveSupport.on_load :active_record do
  require 'will_paginate/active_record'
end

require 'bundler/setup'
Bundler.require :default
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
ActiveRecord::Base.logger = Logger.new(STDOUT) unless ENV['RACK_ENV'] == 'test'

require_relative './app/models'

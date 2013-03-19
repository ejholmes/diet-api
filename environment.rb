require 'active_support'

require 'bundler/setup'
Bundler.require :default
require 'uri'
require 'sinatra/base'
require 'active_record'

database = URI(ENV['DATABASE_URL'] || 'postgres://localhost:5432/reader_development')
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  pool: 5,
  database: database.path[1..-1],
  username: database.user,
  password: database.password,
  host: database.host,
  port: database.port
)

require File.expand_path('../config/environment', __FILE__)

ActiveRecord::Base.logger = Logger.new(STDOUT) unless ENV['RACK_ENV'] == 'test'

run App.app

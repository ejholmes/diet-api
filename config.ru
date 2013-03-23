require File.expand_path('../config/environment', __FILE__)

ActiveRecord::Base.logger = Logger.new(STDOUT)

Diet.setup
run Diet::API.app

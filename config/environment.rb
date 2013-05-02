ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'diet'

Readit::Config.consumer_key = ENV['READABILITY_KEY']
Readit::Config.consumer_secret = ENV['READABILITY_SECRET']

Diet.connect!

require 'pusher'

uri = URI(ENV['PUSHER_URL'] || raise("Please specify the PUSHER_URL"))

Pusher.app_id = uri.path.gsub('/apps/', '').to_i
Pusher.key = uri.user
Pusher.secret = uri.password

require 'pusher'

if url = ENV['PUSHER_URL']
  uri = URI(url)

  Pusher.app_id = uri.path.gsub('/apps/', '').to_i
  Pusher.key = uri.user
  Pusher.secret = uri.password
end

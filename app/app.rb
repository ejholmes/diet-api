require 'models'

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

class CORS
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers['Access-Control-Allow-Origin'] = '*'
    [status, headers, body]
  end
end

class App
  def self.app
    @app ||= Rack::Builder.new {
      use CORS

      use Rack::Session::Cookie, key: '_diet_session', domain: ENV['COOKIE_DOMAIN'], secret: ENV['COOKIE_SECRET'] || 'iebie5oKneequ1Ae'

      use Warden::Manager do |manager|
        manager.default_strategies :basic
        manager.failure_app = lambda { |env|
          [
            401,
            {
              'Content-Type' => 'application/json',
              'Content-Length' => '0',
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

      run API
    }
  end
end

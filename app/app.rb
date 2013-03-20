require 'models'

class App
  def self.app
    @app ||= Rack::Builder.new {
      use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET'] || 'iebie5oKneequ1Ae'

      use OmniAuth::Builder do
        provider :readability, ENV['READABILITY_KEY'], ENV['READABILITY_SECRET']
      end

      run API
    }
  end
end

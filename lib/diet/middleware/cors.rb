module Diet
  module Middleware
    class CORS
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        headers['Access-Control-Allow-Origin'] = ENV['ALLOWED_ORIGIN'] || '*'
        headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, HEAD'
        headers['Access-Control-Allow-Headers'] = '*'
        headers['Access-Control-Allow-Credentials'] = 'true'
        [status, headers, body]
      end
    end
  end
end

module Diet
  module Middleware
    class CORS
      def initialize(app)
        @app = app
      end

      def call(env)
        if env['REQUEST_METHOD'] == 'OPTIONS'
          [200, set_headers({}), []]
        else
          status, headers, body = @app.call(env)
          [status, set_headers(headers), body]
        end
      end

      def set_headers(headers)
        headers['Access-Control-Allow-Origin'] = ENV['ALLOWED_ORIGIN'] || '*'
        headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, HEAD'
        headers['Access-Control-Allow-Headers'] = 'Content-Type'
        headers['Access-Control-Allow-Credentials'] = 'true'
        headers
      end
    end
  end
end

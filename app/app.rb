require 'models'

class App
  def initialize
  end

  def call(env)
    API.call(env)
  end
end

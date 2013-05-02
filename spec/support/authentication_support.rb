module AuthenticationMacros
  def with_authenticated_user
    before do
      login_as current_user
    end

    after do
      Warden.test_reset!
    end
  end
end

RSpec.configure do |config|
  config.include include Warden::Test::Helpers
  config.extend AuthenticationMacros
end
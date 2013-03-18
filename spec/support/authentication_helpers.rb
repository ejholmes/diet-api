module AuthenticationHelpers
  module ControllerHelpers
    def login_user(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = create :user unless user
      sign_in user
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers::ControllerHelpers, type: :controller
  config.include Devise::TestHelpers, type: :controller
end

class Authenticator::UsernamePassword < Authenticator::Base
  attr_reader :username, :password
  
  def initialize(username, password)
    @username = username
    @password = password
  end

  def authenticate!
    return nil unless username.present? && password.present?
    return nil unless user
    password_matches? ? user : nil
  end

private

  def password_matches?
    user.valid_password?(password)
  end

  def user
    @user ||= User.where(email: username).first
  end

end

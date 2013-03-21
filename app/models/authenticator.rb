class Authenticator
  def username_password(username, password)
    return nil unless username.present? && password.present?
    user = User.where(email: username).first
    user.valid_password?(password) ? user : nil
  end
end

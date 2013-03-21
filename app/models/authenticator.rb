class Authenticator
  def username_password(username, password)
    return nil unless username.present? && password.present?
    User.where(email: username, password: password).first
  end
end

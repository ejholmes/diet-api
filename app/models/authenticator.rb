class Authenticator
  def from_token(token)
    return nil unless token.present?
    User.where(token: token).first
  end
end

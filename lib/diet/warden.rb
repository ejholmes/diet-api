Warden::Strategies.add(:basic) do
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(env)
  end

  def authenticate!
    return fail! unless auth.provided?
    return fail!(:bad_request) unless auth.basic?
    username, password = auth.credentials
    user = Authenticator::UsernamePassword.new(username, password).authenticate!
    user.nil? ? fail! : success!(user)
  end
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

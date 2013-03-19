class User
  def subscribe_to(url)
    Subscription.subscribe_to(url, user: self)
  end
end

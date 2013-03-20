class User::Readability < Hash
  def token
    credentials[:token]
  end

  def token=(token)
    credentials[:token] = token
  end

  def secret
    credentials[:secret]
  end

  def secret=(secret)
    credentials[:secret] = secret
  end

  def authorized?
    token.present? && secret.present?
  end

  def enabled?
    authorized? && self[:enabled]
  end

  def enable
    self[:enabled] = true
  end

  def disable
    self[:enabled] = false
  end

  def client
    @client ||= Readit::API.new token, secret
  end

  def bookmark(url)
    client.bookmark url: url
  end

  def dump(obj)
    obj
  end

  def load(hash)
    self.class.new.tap { |o| o.replace(hash) }
  end


private

  def credentials
    self[:credentials] ||= Hash.new
  end

end

class Subscription
  attr_reader :url, :user

  def self.subscribe_to(*args)
    new(*args).subscribe
  end

  def initialize(url, options = {})
    @url = url
    @user = options.fetch(:user)
  end

  def subscribe
    feeds.create(
      xml_url: xml_url,
      html_url: html_url,
      title: title,
      feed_type: type
    )
  end

private

  def feeds
    user.feeds
  end

  def feed
    @feed ||= Feedzirra::Feed.fetch_and_parse(url)
  end

  def title
    feed.title
  end

  def html_url
    feed.url
  end
  
  def xml_url
    url
  end

  def type
    'rss'
  end

end

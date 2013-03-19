class Subscription
  attr_reader :url

  def initialize(url)
    @url = url
    subscribe
  end

  def subscribe
    Feed.create(
      xml_url: xml_url,
      html_url: html_url,
      title: title,
      feed_type: type
    )
  end

private

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

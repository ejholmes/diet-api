class Subscription
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def subscribe
    Feed.create(
      xml_url: xml_url,
      html_url: html_url,
      title: title,
      text: description
    )
  end

private

  delegate :title, :description, to: :feed

  def feed
    @feed ||= Feedzirra::Feed.fetch_and_parse(url)
  end

  def html_url
    feed.url
  end
  
  def xml_url
    url
  end

end

require 'rss'
require 'open-uri'

class Subscription
  attr_reader :url

  def self.subscribe_to(url)
    new(url).subscribe
  end

  def initialize(url)
    @url = url
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
    @feed ||= RSS::Parser.parse(open(url))
  end

  def title
    feed.channel.title
  end

  def html_url
    feed.channel.link
  end
  
  def xml_url
    url
  end

  def type
    'rss'
  end

end

require 'rss'
require 'open-uri'

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

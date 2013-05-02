module FixtureHelpers
  def fixture(path)
    File.read(File.expand_path("../../fixtures/#{path}", __FILE__))
  end

  def feed_xml(feed, options = {})
    options = { type: 'rss' }.merge(options)
    fixture("feeds/#{feed}.#{options.fetch(:type)}")
  end

  def rss_feed(feed)
    feed_xml(feed, type: 'rss')
  end

  def atom_feed(feed)
    feed_xml(feed, type: 'atom')
  end
end

RSpec.configure do |config|
  config.include FixtureHelpers
end

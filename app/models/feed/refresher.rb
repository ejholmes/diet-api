class Feed::Refresher
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def update
    updating!
    entries.reverse.each { |entry| process(entry) }
  ensure
    updated!
  end

private

  delegate :xml, to: :feed
  delegate :entries, to: :xml

  def process(entry)
    EntryProcessor.new(feed, entry).process
  end

  def items
    feed.items
  end

  def updating!
    feed.update_attributes!(updating: true)
  end

  def updated!
    feed.update_attributes!(updating: false, last_update: DateTime.now)
  end

end

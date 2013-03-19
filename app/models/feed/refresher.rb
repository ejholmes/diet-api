class Feed::Refresher
  attr_reader :feed, :count

  def initialize(feed)
    @feed = feed
    @count = items.count
  end

  def update
    updating!
    entries.each { |entry| process(entry) }
  ensure
    notify if items.count > count
    updated!
  end

private

  delegate :xml, to: :feed
  delegate :entries, to: :xml

  def process(entry)
    Item::Processor.new(feed, entry).process
  end

  def items
    feed.items
  end

  def notify
    Pusher['refreshes'].trigger('refresh', feed_id: feed.id)
  end

  def updating!
    feed.update_attributes!(updating: true)
  end

  def updated!
    feed.update_attributes!(updating: false, last_update: DateTime.now)
  end

end

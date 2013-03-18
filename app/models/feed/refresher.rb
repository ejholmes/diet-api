class Feed::Refresher
  attr_reader :feed, :count

  def initialize(feed)
    @feed = feed
    @count = feed.items.count
  end

  def update
    updating!
    items.each { |xml_item| process(xml_item) }
  ensure
    notify if feed.items.count > count
    updated!
  end

private

  delegate :xml, to: :feed
  delegate :items, to: :xml

  def process(xml_item)
    Item::Processor.new(feed, xml_item).process
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

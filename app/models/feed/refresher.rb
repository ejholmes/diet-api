class Feed::Refresher
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def update
    transaction do
      updating!
      items.each { |xml_item| process(xml_item) }
      updated!
    end
  end

private

  delegate :xml, to: :feed
  delegate :items, to: :xml

  def process(xml_item)
    Item::Processor.new(feed, xml_item).process
  end

  def transaction(&block)
    Feed.transaction(&block)
  end

  def updating!
    feed.update_attributes!(updating: true)
  end

  def updated!
    feed.update_attributes!(updating: false, last_update: DateTime.now)
  end

end

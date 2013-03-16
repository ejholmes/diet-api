class Item::Processor
  attr_reader :feed, :item

  def initialize(feed, item)
    @feed = feed
    @item = item
  end

  def process
    if items.exists?(guid: guid)
      update
    else
      create
    end
  end

  def update
    existing.update_attributes(attributes)
  end

  def create
    items.create(attributes.merge(guid: guid))
  end

private

  delegate :title, :description, :link, to: :item

  def existing
    items.where(guid: guid).first
  end

  def attributes
    { title: title,
      description: description,
      link: link,
      pub_date: pub_date }
  end

  def items
    feed.items
  end

  def guid
    item.guid ? item.guid.content : link
  end

  def pub_date
    item.pubDate
  end

end

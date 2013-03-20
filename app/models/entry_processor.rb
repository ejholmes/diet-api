class EntryProcessor
  attr_reader :feed, :entry

  def initialize(feed, entry)
    @feed = feed
    @entry = entry
  end

  def process
    if existing
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

  delegate :url, :published, to: :entry

  def existing
    @existing ||= items.where(guid: guid).first
  end

  def attributes
    { title: title,
      description: content,
      link: url,
      pub_date: published }
  end

  def title
    Sanitize.clean(entry.title)
  end

  def content
    Sanitize.clean(entry.content, Sanitize::Config::RELAXED)
  end

  def items
    feed.items
  end

  def guid
    entry.entry_id || url
  end

end

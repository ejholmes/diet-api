class Item < ActiveRecord::Base
  attr_accessible :description, :guid, :link, :pub_date, :title, :read

  belongs_to :feed

  default_scope order('pub_date DESC')

  def read!
    self.read = true
    self.save!
  end

  class Creator
    attr_reader :feed, :item

    def initialize(feed, item)
      @feed = feed
      @item = item
    end

    def create_or_update
      if items.exists?(guid: guid)
        update
      else
        create
      end
    end

    def update
      items.where(guid: guid).first.update_attributes(attributes)
    end

    def create
      items.create(attributes.merge(guid: guid))
    end

  private

    delegate :title, :description, :link, to: :item

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
end

require 'rss'
require 'open-uri'

class Feed < ActiveRecord::Base
  attr_accessible :html_url, :text, :title, :feed_type, :xml_url

  has_many :items

  def xml
    @xml ||= RSS::Parser.parse(open(xml_url))
  end

  def update
    xml.items.each do |item|
      Item::Creator.new(self, item).create_or_update
    end
  end
end

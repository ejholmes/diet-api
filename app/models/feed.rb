require 'rss'
require 'open-uri'

class Feed < ActiveRecord::Base
  autoload :Refresher, 'feed/refresher'

  attr_accessible :html_url, :text, :title, :feed_type, :xml_url, :updating, :last_update

  has_many :items, dependent: :destroy

  def unread_count
    items.where(read: false).count
  end

  def self.next
    where(updating: false).order('last_update ASC NULLS FIRST').first
  end

  def self.refresh
    scoped.map(&:refresh!)
  end

  def xml
    @xml ||= RSS::Parser.parse(open(xml_url))
  end

  def refresh!
    Feed::Refresher.new(self).update
  end
end

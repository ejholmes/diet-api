require 'rss'
require 'open-uri'

class Feed < ActiveRecord::Base
  autoload :Refresher, 'feed/refresher'

  attr_accessible :html_url, :text, :title, :feed_type, :xml_url, :updating, :last_update

  belongs_to :user
  has_many :items, dependent: :destroy

  default_scope order('title ASC')

  def unread_count
    items.unread.count
  end

  def self.next
    unscoped.where(updating: false).order('last_update ASC NULLS FIRST').first
  end

  def self.refresh
    scoped.map(&:refresh!)
  end

  def html_uri
    @html_uri ||= URI(html_url)
  end

  def domain
    html_uri.host
  end

  def xml
    @xml ||= RSS::Parser.parse(open(xml_url))
  end

  def refresh!
    Feed::Refresher.new(self).update
  end
end

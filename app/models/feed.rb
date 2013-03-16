require 'rss'
require 'open-uri'

class Feed < ActiveRecord::Base
  autoload :Updater, 'feed/updater'

  attr_accessible :html_url, :text, :title, :feed_type, :xml_url, :updating, :last_update

  has_many :items, dependent: :destroy

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
    Feed::Updater.new(self).update
  end
end

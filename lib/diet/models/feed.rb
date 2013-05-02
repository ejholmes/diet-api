class Feed < ActiveRecord::Base
  include Grape::Entity::DSL

  autoload :Refresher, 'diet/models/feed/refresher'

  # Associations
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :unread_items, class_name: 'Item', conditions: { read: false }

  class << self
    def next
      unscoped.where(updating: false).order('last_update ASC NULLS FIRST').first
    end
  end

  def html_uri
    @html_uri ||= URI(html_url)
  rescue
    nil
  end

  def domain
    return nil unless html_uri
    html_uri.host
  end

  def favicon
    "http://s2.googleusercontent.com/s2/favicons?domain=#{domain}&alt=feed"
  end

  def xml
    @xml ||= Feedzirra::Feed.fetch_and_parse(xml_url)
  end

  def refresh!
    Feed::Refresher.new(self).refresh
  end

  def entity(options = {})
    Entity.new(self, options)
  end

  entity :id, :title, :text, :html_url, :xml_url, :favicon, :last_update do
    expose :unread_count, as: :unread
  end
end

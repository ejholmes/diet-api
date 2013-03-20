class Feed < ActiveRecord::Base
  include Grape::Entity::DSL

  # Associations
  belongs_to :user
  has_many :items, dependent: :destroy

  class << self
    def next
      unscoped.where(updating: false).order('last_update ASC NULLS FIRST').first
    end
  end

  def unread_count
    items.unread.count
  end

  def html_uri
    @html_uri ||= URI(html_url)
  end

  def domain
    html_uri.host
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

  entity :id, :title, :text, :html_url, :xml_url, :last_update do
    expose :unread_count, as: :unread
  end
end

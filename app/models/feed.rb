class Feed < ActiveRecord::Base
  has_many :items, dependent: :destroy

  class << self
    def next
      unscoped.where(updating: false).order('last_update ASC NULLS FIRST').first
    end
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
end

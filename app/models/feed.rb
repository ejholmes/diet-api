class Feed < ActiveRecord::Base
  #belongs_to :user
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
    Feed::Refresher.new(self).update
  end

  def as_json(state)
    { id: id,
      title: title,
      text: text,
      html_url: html_url,
      xml_url: xml_url,
      last_update: last_update,
      feed_type: feed_type }.to_json
  end
end

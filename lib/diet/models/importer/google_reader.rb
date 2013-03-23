module Importer
  class GoogleReader < Base
    attr_reader :file, :user

    def initialize(file, options = {})
      @file = file
      @user = options.fetch(:user)
    end

    def import
      subscriptions = []
      outlines.collect do |node|
        subscriptions << subscribe(node['xmlUrl']) if node['xmlUrl']
      end
      subscriptions
    end

  private

    def subscribe(url)
      user.subscribe_to(url)
    rescue
      # Whatever
    end

    def opml
      @opml ||= Nokogiri::XML::Document.parse(file)
    end

    def outlines
      opml.xpath('//opml/body//outline')
    end

  end
end

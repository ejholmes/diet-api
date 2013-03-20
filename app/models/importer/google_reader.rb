module Importer
  class GoogleReader < Base
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def import
      outlines.each do |node|
        subscribe node['xmlUrl'] if node['xmlUrl']
      end
    end

  private

    def subscribe(url)
      Subscription.new(url).subscribe
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

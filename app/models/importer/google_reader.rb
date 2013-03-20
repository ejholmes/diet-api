require 'rexml/Document'

module Importer
  class GoogleReader < Base
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def import
      process(elements)
    end

  private

    def process(node)
      if node.elements.size > 0
        node.elements.each('outline') do |node|
          process(node)
        end
      else
        subscribe node.attributes['xmlUrl']
      end
    end

    def subscribe(url)
      Subscription.new(url).subscribe
    rescue
      # Whatever
    end

    def opml
      @opml ||= REXML::Document.new(file)
    end

    def elements
      opml.elements['opml/body']
    end

  end
end

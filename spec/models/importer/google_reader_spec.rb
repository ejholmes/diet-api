require 'spec_helper'

describe Importer::GoogleReader do
  let(:xml) { File.read(File.expand_path('../../../fixtures/importer/google_reader/subscriptions.xml', __FILE__)) }
  let(:user) { double('user') }
  let(:importer) { described_class.new(xml, user: user) }

  describe '.import' do
    it 'creates a new feed for each imported subscription' do
      importer.should_receive(:subscribe).with('http://blog.boxee.tv/feed/')
      importer.should_receive(:subscribe).with('http://howtonode.org/feed.xml')
      importer.should_receive(:subscribe).with('http://feeds.feedburner.com/codeclimate')
      importer.should_receive(:subscribe).with('http://www.sparkfun.com/feeds/news')
      importer.import
    end
  end
end

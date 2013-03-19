require 'spec_helper'

describe Feed do
  let(:feed) { create :feed }

  it { should have_many(:items) }

  before do
    stub_request(:get, feed.xml_url).to_return(body: feed_xml(:svn))
  end

  describe '.xml' do
    subject { feed.xml }
    it { should be_a String }
  end

  describe '.refresh!' do
    it 'updates the feed items' do
      EntryProcessor.should_receive(:new).exactly(10).times.and_return(stub(:process => nil))
      feed.refresh!
    end
  end
end

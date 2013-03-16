require 'spec_helper'

describe Feed do
  let(:feed) { create :feed }

  it { should have_many(:items) }

  before do
    stub_request(:get, feed.xml_url).to_return(body: feed_xml(:svn))
  end

  describe '.xml' do
    subject { feed.xml }
    it { should be_a RSS::Rss }
  end

  describe '.update' do
    it 'updates the feed items' do
      Item::Creator.should_receive(:new).exactly(10).times.and_return(stub(:create_or_update => nil))
      feed.update
    end
  end
end

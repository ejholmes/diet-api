require 'spec_helper'

describe Feed do
  let(:feed) { create :feed }

  it { should have_many(:items) }

  before do
    feed.stub(:xml).and_return(Feedzirra::Feed.parse(rss_feed(:svn)))
  end

  describe '.refresh!' do
    it 'updates the feed items' do
      EntryProcessor.should_receive(:new).exactly(10).times.and_return(stub(:process => nil))
      feed.refresh!
    end
  end

  describe '.domain' do
    subject { feed.domain }

    before do
      feed.html_url = 'http://github.com'
    end

    it { should eq 'github.com' }
  end

  describe '.unread_count' do
    subject { feed.unread_count }

    before do
      2.times { create :item, feed: feed, read: true }
      3.times { create :item, feed: feed, read: false }
    end

    it { should eq 3 }
  end
end

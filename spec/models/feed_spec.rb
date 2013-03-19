require 'spec_helper'

describe Feed do
  let(:feed) { create :feed }

  it { should have_many(:items) }

  before do
    feed.stub(:xml).and_return(Feedzirra::Feed.parse(feed_xml(:svn)))
  end

  describe '.refresh!' do
    it 'updates the feed items' do
      EntryProcessor.should_receive(:new).exactly(10).times.and_return(stub(:process => nil))
      feed.refresh!
    end
  end
end

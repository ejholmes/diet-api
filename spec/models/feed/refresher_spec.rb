require 'spec_helper'

describe Feed::Refresher do
  let(:feed) { double('feed') }
  let(:refresher) { described_class.new(feed) }

  before do
    feed.stub(:xml).and_return(Feedzirra::Feed.parse(rss_feed(:svn)))
  end

  describe '.refresh' do
    before do
      feed.should_receive(:update_attributes!).with(updating: true).ordered
    end

    it 'processes each entry' do
      EntryProcessor.should_receive(:new).with(feed, kind_of(Feedzirra::Parser::RSSEntry)).exactly(10).times.and_return(stub(process: nil))
      feed.should_receive(:update_attributes!).with(updating: false, last_update: kind_of(DateTime)).ordered
      refresher.refresh
    end

    context 'when an exception is raised' do
      it 'sets updating to false' do
        refresher.stub(:process).and_raise('Really bad exception')
        feed.should_receive(:update_attributes!).with(updating: false, last_update: kind_of(DateTime)).ordered
        expect { refresher.refresh }.to raise_error('Really bad exception')
      end
    end
  end
end

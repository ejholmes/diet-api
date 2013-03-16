require 'spec_helper'

describe Item::Creator do
  let(:feed) { double('feed') }
  let(:feed_items) { double('feed items') }
  let(:item) { double('item').as_null_object }
  let(:creator) { described_class.new(feed, item) }

  before do
    feed.stub(:items).and_return(feed_items)
  end

  describe '.create' do
    it 'creates a feed item' do
      feed_items.should_receive(:create)
      creator.create
    end
  end

  describe '.update' do
    it 'updates the feed item' do
      item.stub(:guid).and_return(stub(:content => 'http://guid.org'))
      feed_items.stub(:where).with(guid: 'http://guid.org').and_return(stub(:first => item))
      item.should_receive(:update_attributes)
      creator.update
    end
  end

  describe '.create_or_update' do
    context 'when the item exists' do
      it 'calls update' do
        feed_items.stub(:exists?).and_return(true)
        creator.should_receive(:update)
        creator.create_or_update
      end
    end

    context 'when the item does not exist' do
      it 'calls create' do
        feed_items.stub(:exists?).and_return(false)
        creator.should_receive(:create)
        creator.create_or_update
      end
    end
  end
end

require 'spec_helper'

describe EntryProcessor do
  let(:feed) { double('feed') }
  let(:feed_items) { double('feed items') }
  let(:item) { double('item').as_null_object }
  let(:processor) { described_class.new(feed, item) }

  before do
    feed.stub(:items).and_return(feed_items)
  end

  describe '.create' do
    it 'creates a feed item' do
      feed_items.should_receive(:create)
      processor.create
    end
  end

  describe '.update' do
    it 'updates the feed item' do
      item.stub(:guid).and_return(stub(:content => 'http://guid.org'))
      feed_items.stub(:where).with(guid: 'http://guid.org').and_return(stub(:first => item))
      item.should_receive(:update_attributes)
      processor.update
    end
  end

  describe '.process' do
    context 'when the item exists' do
      it 'calls update' do
        processor.stub(:existing).and_return(true)
        processor.should_receive(:update)
        processor.process
      end
    end

    context 'when the item does not exist' do
      it 'calls create' do
        processor.stub(:existing).and_return(nil)
        processor.should_receive(:create)
        processor.process
      end
    end
  end
end

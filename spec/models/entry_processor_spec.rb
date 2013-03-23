require 'spec_helper'

describe EntryProcessor do
  let(:feed) { double('feed') }
  let(:feed_items) { double('feed items') }
  let(:entry) { double('entry').as_null_object }
  let(:processor) { described_class.new(feed, entry) }

  before do
    feed.stub(:items).and_return(feed_items)
  end

  describe '.create' do
    let(:readability) { double('readability') }

    before do
      feed.stub_chain(:user, :readability).and_return(readability)
      feed_items.should_receive(:create).and_return(stub(link: 'http://www.google.com', entity: nil))
    end

    context 'when readability is disabled' do
      before do
        readability.stub(:enabled?).and_return(false)
      end

      it 'creates a feed item' do
        processor.create
      end
    end

    context 'when readability is enabled' do
      before do
        readability.stub(:enabled?).and_return(true)
        processor.should_receive(:bookmark).with('http://www.google.com')
      end

      it 'creates a feed item and bookmarks the link on readability' do
        processor.create
      end
    end
  end

  describe '.update' do
    it 'updates the feed entry' do
      entry.stub(:entry_id).and_return('http://guid.org')
      feed_items.stub(:where).with(guid: 'http://guid.org').and_return(stub(:first => entry))
      entry.should_receive(:update_attributes)
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

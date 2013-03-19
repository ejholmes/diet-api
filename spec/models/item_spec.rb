require 'spec_helper'

describe Item do
  let(:item) { create :item }

  it { should belong_to :feed }

  describe '.read!' do
    let(:item) { create :item, read: false }
    it 'marks the item as read' do
      item.read!
      expect(item).to be_read
    end
  end

  describe '.unread!' do
    let(:item) { create :item, read: true }
    it 'marks the item as unread' do
      item.unread!
      expect(item).to_not be_read
    end
  end
end

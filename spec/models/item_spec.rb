require 'spec_helper'

describe Item do
  let(:item) { create :item }

  it { should belong_to :feed }

  describe 'scopes' do
    describe '#read' do
      subject { described_class.read }

      before do
        create :item, read: false
        create :item, read: true
      end

      its(:count) { should eq 1 }
      its(:first) { should be_read }
    end

    describe '#unread' do
      subject { described_class.unread }

      before do
        create :item, read: false
        create :item, read: true
      end

      its(:count) { should eq 1 }
      its(:first) { should_not be_read }
    end
  end

  describe '#read!' do
    before do
      3.times { create :item, read: false }
    end

    it 'marks all items as read' do
      Item.read!
      Item.all.each { |item| expect(item).to be_read }
    end
  end

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

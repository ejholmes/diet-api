require 'spec_helper'

describe Item do
  let(:item) { create :item }

  it { should belong_to :feed }

  describe '.read!' do
    it 'marks the item as read' do
      item.read!
      expect(item).to be_read
    end
  end
end

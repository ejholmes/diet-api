require 'spec_helper'

describe Feed do
  let(:feed) { create :feed }

  it { should have_many(:items) }

  describe '.xml' do
    subject { feed.xml }
    before do
      stub_request(:get, feed.xml_url).to_return(body: feed_xml(:svn))
    end

    it { should be_a RSS::Rss }
  end
end

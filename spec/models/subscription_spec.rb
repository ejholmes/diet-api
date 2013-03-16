require 'spec_helper'

describe Subscription do
  let(:url) { Faker::Internet.url }
  let(:subscription) { described_class.new(url) }

  before do
    stub_request(:get, url).to_return(body: feed_xml(:svn))
  end

  describe '.subscribe' do
    subject { subscription.subscribe }

    it 'creates a new feed' do
      expect { subscription.subscribe }.to change(Feed, :count).by(1)
    end

    its(:title) { should eq 'Signal vs. Noise' }
    its(:html_url) { should eq 'http://37signals.com/svn/posts' }
    its(:xml_url) { should eq url }
    its(:feed_type) { should eq 'rss' }
  end
end

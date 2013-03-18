require 'spec_helper'

describe Subscription do
  let(:url) { Faker::Internet.url }
  let(:user) { create :user }
  let(:subscription) { described_class.new(url, user: user) }

  before do
    stub_request(:get, url).to_return(body: feed_xml(:svn))
  end

  describe '#subscribe_to' do
    it 'delegates to .subscribe' do
      subscription = double('subscription')
      Subscription.should_receive(:new).and_return(subscription)
      subscription.should_receive(:subscribe)
      described_class.subscribe_to(url)
    end
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

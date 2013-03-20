require 'spec_helper'

describe Subscription do
  let(:url) { 'http://github.com/blog.atom' }
  let(:user) { double('user', feeds: Feed) }
  let(:subscription) { described_class.new(url, user: user) }

  before do
    subscription.stub(:feed).and_return(Feedzirra::Feed.parse(rss_feed(:svn)))
  end

  describe '.describe' do
    subject { subscription.subscribe }

    it 'creates a new feed' do
      expect { subject }.to change(Feed, :count).by(1)
    end

    context 'with an rss feed' do
      its(:xml_url)   { should eq url }
      its(:html_url)  { should eq 'http://37signals.com/svn/posts' }
      its(:title)     { should eq 'Signal vs. Noise' }
      its(:text)      { should eq 'Signal vs. Noise' }
    end

    context 'with an atom feed' do
      before do
        subscription.stub(:feed).and_return(Feedzirra::Feed.parse(atom_feed(:github)))
      end

      its(:xml_url)   { should eq url }
      its(:html_url)  { should eq 'https://github.com/blog' }
      its(:title)     { should eq 'The GitHub Blog' }
      its(:text)      { should be_nil }
    end
  end
end

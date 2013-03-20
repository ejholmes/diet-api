require 'spec_helper'

describe User::Readability do
  let(:hash) { Hash.new }
  let(:readability) { described_class.new.tap { |o| o.replace(hash) } }
  subject { readability }

  describe '.token' do
    subject { readability.token }

    context 'when not present' do
      it { should be_nil }
    end

    context 'when present' do
      let(:hash) { { credentials: { token: 'foobar' } } }
      it { should eq 'foobar' }
    end
  end

  describe '.secret' do
    subject { readability.secret }

    context 'when not present' do
      it { should be_nil }
    end

    context 'when present' do
      let(:hash) { { credentials: { secret: 'foobar' } } }
      it { should eq 'foobar' }
    end
  end

  describe '.authorized?' do
    context 'when the token and secret are not present' do
      it { should_not be_authorized }
    end
    
    context 'when token and secret are present' do
      before do
        readability.token  = 'foo'
        readability.secret = 'bar'
      end

      it { should be_authorized }
    end
  end

  describe '.enabled?' do
    context 'when authorized' do
      before do
        readability.stub(:authorized?).and_return(true)
      end

      context 'and enabled' do
        let(:hash) { { enabled: true } }
        it { should be_enabled }
      end

      context 'and enabled' do
        let(:hash) { { enabled: false } }
        it { should_not be_enabled }
      end
    end

    context 'when not authorized' do
      before do
        readability.stub(:authorized?).and_return(false)
      end

      context 'and enabled' do
        let(:hash) { { enabled: true } }
        it { should_not be_enabled }
      end

      context 'and enabled' do
        let(:hash) { { enabled: false } }
        it { should_not be_enabled }
      end
    end
  end

  describe '.client' do
    subject { readability.client }
    it { should be_a Readit::API }
  end

  describe '.bookmark' do
    let(:url) { 'http://www.google.com' }

    it 'creates a bookmark' do
      readability.client.should_receive(:bookmark).with(url: url)
      readability.bookmark(url)
    end
  end
end

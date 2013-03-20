require 'spec_helper'

describe User do
  let(:user) { create :user }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should have_many(:feeds) }
  it { should have_many(:items).through(:feeds) }

  describe '#new' do
    it 'initializes a token' do
      user = described_class.new(email: 'foo@example.com')
      user.save
      expect(user.token).to be_present
    end
  end

  describe '#authenticate' do
    subject { described_class.authenticate(token) }

    context 'when the token is found' do
      let(:token) { user.token }
      it { should eq user }
    end

    context 'when the token is not found' do
      let(:token) { 'foobar' }
      it { should be_nil }
    end
  end

  describe '.subscribe_to' do
    let(:url) { 'http://github.com/blog.atom' }

    it 'subscribes the user to a feed' do
      Subscription.should_receive(:new).with(url, user: user).and_return(stub(subscribe: nil))
      user.subscribe_to(url)
    end
  end
end

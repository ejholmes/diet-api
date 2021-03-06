require 'spec_helper'

describe User do
  let(:user) { create :user }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }

  it { should have_many(:feeds) }
  it { should have_many(:items).through(:feeds) }

  it { should serialize(:readability).as(User::Readability) }

  describe '.subscribe_to' do
    let(:url) { 'http://github.com/blog.atom' }

    it 'subscribes the user to a feed' do
      Subscription.should_receive(:new).with(url, user: user).and_return(stub(subscribe: nil))
      user.subscribe_to(url)
    end
  end

  describe '.readability' do
    subject { user.readability }
    it { should be_a User::Readability }
  end
end

require 'spec_helper'

describe User do
  let(:user) { create :user }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

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
end

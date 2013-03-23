require 'spec_helper'

describe Authenticator::UsernamePassword do
  let(:username) { 'foo@example.com' }
  let(:password) { 'foobar' }
  let(:authenticator) { described_class.new(username, password) }

  describe '.authenticate!' do
    subject { authenticator.authenticate! }

    context 'when the username and password and empty' do
      let(:username) { '' }
      let(:password) { '' }
      it { should be_nil }
    end

    context 'when the user is not found' do
      before do
        authenticator.stub(:user).and_return(nil)
      end

      it { should be_nil }
    end

    context 'when the password does not match' do
      before do
        authenticator.stub(:password_matches?).and_return(false)
      end

      it { should be_nil }
    end

    context 'when the password matches' do
      let(:user) { double('user', valid_password?: true) }

      before do
        authenticator.stub(:user).and_return(user)
      end

      it { should eq user }
    end
  end
end

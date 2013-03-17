require 'spec_helper'

describe SubscriptionsController do
  describe 'GET index' do
    before do
      get :index
    end

    it { should assign_to(:subscriptions).with(Feed.all) }
  end

  describe 'POST subscribe' do
    let(:url) { 'http://xml.org/feed' }
    let(:feed) { create :feed }

    before do
      User.any_instance.should_receive(:subscribe_to).with(url).and_return(stub(:refresh! => feed))
      post :subscribe, url: url, format: :json
    end

    it { should respond_with(201) }
  end

  describe 'DELETE unsubscribe' do
    let(:feed) { create :feed }

    before do
      delete :unsubscribe, id: feed.id, format: :json
    end

    it { should respond_with(204) }
  end
end

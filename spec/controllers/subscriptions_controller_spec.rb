require 'spec_helper'

describe SubscriptionsController do
  let(:user) { create :user }

  before do
    login_user user
  end

  describe 'GET index' do
    before do
      get :index
    end

    it { should assign_to(:subscriptions).with(Feed.all) }
  end

  describe 'DELETE unsubscribe' do
    let(:feed) { create :feed, user: user }

    before do
      delete :unsubscribe, id: feed.id, format: :json
    end

    it { should respond_with(204) }
  end
end

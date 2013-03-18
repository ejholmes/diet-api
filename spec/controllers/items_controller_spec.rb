require 'spec_helper'

describe ItemsController do
  let(:user) { create :user }
  let(:feed) { create :feed, user: user }

  before do
    login_user user
  end

  describe 'GET index' do
    before do
      get :index
    end

    it { should assign_to(:items).with(Item.all) }
  end

  describe 'PUT read' do
    let(:item) { create :item, feed: feed }

    before do
      put :read, id: item.id, format: :json
    end

    it { should respond_with(204) }
  end

  describe 'DELETE read' do
    let(:item) { create :item, feed: feed }

    before do
      delete :read, id: item.id, format: :json
    end

    it { should respond_with(204) }
  end
end

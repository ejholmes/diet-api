require 'spec_helper'

describe API do
  include Rack::Test::Methods

  def app
    API
  end

  before do
    Subscription.any_instance.stub(:feed).and_return(Feedzirra::Feed.parse(atom_feed(:github)))
  end

  describe 'Items' do
    describe 'GET /items' do
      it 'responds with a list of items' do
        item = create :item
        get '/items'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq Array(item.entity).to_json
      end

      context 'with a feed specified' do
        it 'responds with a list of items in that feed' do
          feed = create :feed
          item = create :item, feed: feed
          3.times { create :item }
          get "/items?subscription=#{feed.id}"
          expect(last_response.status).to eq 200
          expect(last_response.body).to eq Array(item.entity).to_json
        end
      end

      context 'with pagination' do
        it 'responds with a paginated list of items' do
          100.times { create :item }
          get '/items?page=2'
          expect(JSON.parse(last_response.body).length).to eq 25
        end
      end
    end

    describe 'GET /items/unread' do
      it 'responds with a list of items that are unread' do
        create :item, read: true
        item = create :item
        get '/items/unread'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq Array(item.entity).to_json
      end
    end

    describe 'PUT /items/read' do
      it 'marks all items as read' do
        5.times { create :item, read: true  }
        5.times { create :item, read: false }
        put '/items/read'
        Item.all.each { |item| expect(item).to be_read }
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq '10'
      end
    end

    describe 'PUT /items/:id/read' do
      it 'marks the item as read' do
        item = create :item
        put "/items/#{item.id}/read"
        item.assign_attributes(read: true)
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq item.entity.to_json
      end
    end

    describe 'PUT /items/:id/unread' do
      it 'marks the item as unread' do
        item = create :item, read: true
        put "/items/#{item.id}/unread"
        item.assign_attributes(read: false)
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq item.entity.to_json
      end
    end
  end

  describe 'Subscriptions' do
    describe 'GET /subscriptions' do
      it 'responds with a list of items' do
        subscription = create :feed
        get '/subscriptions'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq Array(subscription.entity).to_json
      end
    end

    describe 'POST /subscriptions' do
      it 'subscribes to a new feed' do
        post '/subscriptions?url=http://github.com/blog.atom'
        expect(last_response.status).to eq 201
        expect(last_response.body).to eq Feed.first.entity.to_json
      end
    end

    describe 'DELETE /subscriptions/:id' do
      it 'removes the subscription' do
        subscription = create :feed
        delete "/subscriptions/#{subscription.id}"
        expect(last_response.status).to eq 200
      end
    end
  end
end

require 'spec_helper'

describe API do
  include Rack::Test::Methods

  def app
    API
  end

  let(:current_user) { create :user }

  before do
    Subscription.any_instance.stub(:feed).and_return(Feedzirra::Feed.parse(atom_feed(:github)))
    User.stub(:authenticate).and_return(current_user)
  end

  describe 'Items' do
    let(:feed) { create :feed, user: current_user}

    describe 'GET /items' do
      it 'responds with a list of items' do
        item = create :item, feed: feed
        get '/items'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq Array(item.entity).to_json
      end

      context 'with a feed specified' do
        it 'responds with a list of items in that feed' do
          item = create :item, feed: feed
          3.times { create :item }
          get "/items?subscription=#{feed.id}"
          expect(last_response.status).to eq 200
          expect(last_response.body).to eq Array(item.entity).to_json
        end
      end

      context 'with pagination' do
        it 'responds with a paginated list of items' do
          100.times { create :item, feed: feed }
          get '/items?page=2'
          expect(JSON.parse(last_response.body).length).to eq 25
        end
      end
    end

    describe 'GET /items/unread' do
      it 'responds with a list of items that are unread' do
        create :item, feed: feed, read: true
        item = create :item, feed: feed
        get '/items/unread'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq Array(item.entity).to_json
      end
    end

    describe 'GET /items/:id' do
      it 'returns the item' do
        item = create :item, feed: feed
        get "/items/#{item.id}"
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq item.entity(type: :full).to_json
      end
    end

    describe 'PUT /items/read' do
      it 'marks all items as read' do
        5.times { create :item, feed: feed, read: true  }
        5.times { create :item, feed: feed, read: false }
        put '/items/read'
        current_user.items.all.each { |item| expect(item).to be_read }
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq '10'
      end
    end

    describe 'PUT /items/:id/read' do
      it 'marks the item as read' do
        item = create :item, feed: feed
        put "/items/#{item.id}/read"
        item.assign_attributes(read: true)
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq item.entity.to_json
      end
    end

    describe 'PUT /items/:id/unread' do
      it 'marks the item as unread' do
        item = create :item, feed: feed, read: true
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
        subscription = create :feed, user: current_user
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
        subscription = create :feed, user: current_user
        delete "/subscriptions/#{subscription.id}"
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'Import' do
    describe 'POST /import/google_reader' do
      it 'imports all subscriptions' do
        Importer::GoogleReader.should_receive(:new).and_return(stub(import: nil))
        post '/import/google_reader',
          'file' => Rack::Test::UploadedFile.new(File.expand_path('../fixtures/importer/google_reader/subscriptions.xml', __FILE__), "image/jpeg")
        expect(last_response.status).to eq 201
        expect(last_response.body).to eq 'Ok'.to_json
      end
    end
  end

  describe 'Users' do
    describe 'POST /users' do
      context 'with success' do
        it 'creates a new user' do
          post '/users?email=foo@example.com'
          expect(last_response.status).to eq 201
          expect(last_response.body).to eq User.last.entity.to_json
        end
      end

      context 'with errors' do
        it 'returns the errors' do
          user = create :user
          post "/users?email=#{user.email}"
          expect(last_response.status).to eq 400
          expect(last_response.body).to eq({ error: { email: ['has already been taken'] } }.to_json)
        end
      end
    end
  end
end

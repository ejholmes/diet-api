require 'spec_helper'

describe Diet::API::App do
  include Rack::Test::Methods

  def app
    Diet::API.app
  end

  let(:current_user) { create :user }

  before do
    Subscription.any_instance.stub(:feed).and_return(Feedzirra::Feed.parse(atom_feed(:github)))
  end

  describe 'Items' do
    with_authenticated_user

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

      context 'with unread' do
        it 'responds with a list of items that are unread' do
          create :item, feed: feed, read: true
          item = create :item, feed: feed
          get '/items?unread=1'
          expect(last_response.status).to eq 200
          expect(last_response.body).to eq Array(item.entity).to_json
        end
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
      before do
        5.times { create :item, feed: feed, read: true  }
        5.times { create :item, feed: feed, read: false }
      end

      context 'without params' do
        it 'marks all items as read' do
          put '/items/read'
          current_user.items.all.each { |item| expect(item).to be_read }
          expect(last_response.status).to eq 200
          expect(last_response.body).to eq({ total: 5 }.to_json)
        end
      end

      context 'with params[:ids]' do
        it 'marks those ids as read' do
          ids = Item.unread.first(2).collect(&:id)
          put '/items/read', ids: ids
          current_user.items.where(id: ids).each { |item| expect(item).to be_read }
          expect(last_response.status).to eq 200
          expect(last_response.body).to eq({ total: 2 }.to_json)
        end
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
    with_authenticated_user

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
        post '/subscriptions', url: 'http://github.com/blog.atom'
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
    with_authenticated_user

    describe 'POST /import/google_reader' do
      it 'imports all subscriptions' do
        Importer::GoogleReader.should_receive(:new).and_return(stub(import: Feed.all))
        post '/import/google_reader',
          'file' => Rack::Test::UploadedFile.new(File.expand_path('../fixtures/importer/google_reader/subscriptions.xml', __FILE__), "image/jpeg")
        expect(last_response.status).to eq 201
        expect(last_response.body).to eq Feed.all.to_json
      end
    end
  end

  describe 'Users' do
    describe 'POST /users' do
      context 'with success' do
        it 'creates a new user' do
          post '/users', email: 'foo@example.com', password: 'foobar'
          expect(last_response.status).to eq 201
          expect(last_response.body).to eq User.last.entity.to_json
        end
      end

      context 'with errors' do
        it 'returns the errors' do
          user = create :user
          post '/users', email: user.email, password: 'foobar'
          expect(last_response.status).to eq 400
          expect(last_response.body).to eq({ error: { email: ['has already been taken'] } }.to_json)
        end
      end
    end

    describe 'Readability' do
      with_authenticated_user

      describe 'Authorize' do
        before do
          OmniAuth.config.mock_auth[:readability] = OmniAuth::AuthHash.new(
            provider: 'readability',
            credentials: {
              token: 'token',
              secret: 'secret'
            }
          )
        end

        describe 'GET /users/readability/authorize' do
          it 'authorizes readability for the current user' do
            get '/user/readability/authorize'
            follow_redirect!
            follow_redirect!
            expect(last_response.status).to eq 200
            expect(last_response.body).to eq 'Ok'.to_json
          end
        end
      end

      describe 'PUT /user/readability' do
        context 'when the user has already authorized readability' do
          before do
            current_user.readability.stub(:authorized?).and_return(true)
          end

          it 'enables readability' do
            put '/user/readability'
            expect(last_response.status).to eq 200
            expect(last_response.body).to eq current_user.entity.to_json
          end
        end

        context 'when the user has not authorized readability' do
          before do
            current_user.readability.stub(:authorized?).and_return(false)
          end

          it 'returns an error' do
            put '/user/readability'
            expect(last_response.status).to eq 400
            expect(last_response.body).to eq({ error: 'You need to authorize readability first.'}.to_json)
          end
        end
      end

      describe 'DELETE /user/readability' do
        it 'disables readability' do
          delete '/user/readability'
          expect(last_response.status).to eq 200
          expect(last_response.body).to eq current_user.entity.to_json
        end
      end
    end
  end

end

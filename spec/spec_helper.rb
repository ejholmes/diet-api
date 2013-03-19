require 'spork'

module FixtureHelpers
  def fixture(path)
    File.read(File.expand_path("../fixtures/#{path}", __FILE__))
  end

  def feed_xml(feed)
    fixture("feeds/#{feed}.xml")
  end
end

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV['RACK_ENV'] ||= 'test'
  ENV['DATABASE_URL'] ||= 'postgres://localhost:5432/reader_test'

  require File.expand_path('../../app', __FILE__)
  Bundler.require :default, :test
  require 'shoulda/matchers/integrations/rspec'
  require 'rspec/autorun'
  require 'webmock/rspec'
  require 'factory_girl'
  require File.expand_path('../factories', __FILE__)

  WebMock.disable_net_connect! allow_localhost: true

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    config.treat_symbols_as_metadata_keys_with_true_values = true

    # Database Cleaner
    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, js: true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.include FixtureHelpers
    config.include FactoryGirl::Syntax::Methods
  end
end

Spork.each_run do
  FactoryGirl.reload
  I18n.backend.reload!
end

source 'https://rubygems.org'

gem 'rails',        '~> 3.2.12'
gem 'jquery-rails', '~> 2.2.1'
gem 'haml',         '~> 4.0.0'
gem 'thin',         '~> 1.5.0'
gem 'rabl',         '~> 0.7.10'
gem 'pg',           '~> 0.14.1'
gem 'pusher'

# Authentication
gem 'devise'

# Turbolinks
gem 'turbolinks'

# Twitter bootstrap
gem 'bootstrap-sass',          '~> 2.2.2.0'
gem 'font-awesome-sass-rails', '~> 3.0.0.1'
gem 'formtastic-bootstrap',    '~> 2.0.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bourbon',      '~> 3.1'
  gem 'uglifier',     '>= 1.0.3'
  gem 'underscore-rails', '~> 1.4.3'
  gem 'backbone-rails',   '~> 0.9.2'
end

group :development do
  gem 'heroku'
  gem 'heroku_san'
  gem 'foreman'
end

group :development, :test do
  gem 'faker'
  gem 'rspec-rails', '~> 2.13'
end

group :test do
  gem 'capybara',           '~> 2.0.2'
  gem 'poltergeist',        '~> 1.1.0'
  gem 'webmock',            '~> 1.11.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'shoulda-matchers',   '~> 1.4.2'
  gem 'database_cleaner',   '~> 0.9.1'
end

group :development, :test do
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'ruby_gntp'
  gem 'rb-fsevent'
end

group :development, :test do
  gem 'konacha'
  gem 'chai-jquery-rails'
  gem 'sinon-chai-rails'
  gem 'sinon-rails'
  gem 'ejs'
end

group :production do
  gem 'memcachier'
  gem 'dalli'
end

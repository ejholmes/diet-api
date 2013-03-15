source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem "haml"
gem "thin"
group :development do
  gem "heroku"
  gem "heroku_san"
  gem "foreman"
end

group :development, :test do
  gem "faker"
  gem "rspec-rails"
end

group :test do
  gem "capybara"
  gem "poltergeist"
  gem "webmock"
  gem "factory_girl_rails"
  gem "shoulda-matchers"
  gem "database_cleaner"
end

group :development, :test do
  gem "guard-rspec"
  gem "guard-spork"
  gem "ruby_gntp"
  gem "rb-fsevent"
end

group :development, :test do
  gem "konacha"
  gem "chai-jquery-rails"
  gem "sinon-chai-rails"
  gem "sinon-rails"
  gem "ejs"
end

group :production do
  gem "pg"
end

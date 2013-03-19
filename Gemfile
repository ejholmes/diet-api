source :rubygems

gem 'rake'
gem 'sinatra',      '~> 1.4.1'
gem 'activesupport'
gem 'json'

# RSS/Atom
gem 'feedzirra'

# Readability
gem 'readit'

# Database
gem 'pg',           '~> 0.14.1'
gem 'activerecord', '~> 3.2.12'

group :development, :test do
  gem 'faker'
end

group :test do
  gem 'webmock',            '~> 1.11.0'
  gem 'shoulda-matchers',   '~> 1.4.2'
  gem 'database_cleaner',   '~> 0.9.1'
  gem 'factory_girl'
end

group :development, :test do
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'ruby_gntp'
  gem 'rb-fsevent'
end

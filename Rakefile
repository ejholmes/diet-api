#!/usr/bin/env rake
require File.expand_path('../environment', __FILE__)

namespace :updater do
  task :run do
    STDOUT.sync = true
    loop do
      feed = Feed.next
      if feed
        puts "Updating #{feed.title}"
        feed.refresh!
      end
      sleep 5
    end
  end
end

task :default => [:spec]

require 'rspec/core/rake_task'
desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

namespace :db do
  desc "Create the database using DATABASE_URL"
  task :create do
    ActiveRecord::Base.establish_connection(database_config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.create_database(database_config['database'])
    ActiveRecord::Base.establish_connection(database_config)
  end

  desc "Drop the database using DATABASE_URL"
  task :drop do
    ActiveRecord::Base.establish_connection(database_config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.drop_database database_config['database']
  end

  desc "Run the migration(s)"
  task :migrate do
    path = File.expand_path('../db/migrate', __FILE__)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate(path)

    Rake::Task["db:schema:dump"].invoke
  end

  namespace :schema do
    desc "Dump the database schema into a standard Rails schema.rb file"
    task :dump do
      require "active_record/schema_dumper"

      path = File.expand_path('../schema.rb', __FILE__)

      File.open(path, "w:utf-8") do |fd|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, fd)
      end
    end
  end
end

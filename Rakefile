#!/usr/bin/env rake
require File.expand_path('../config/environment', __FILE__)

desc 'Start an irb session'
task :console do
  require 'irb'
  ARGV.clear
  IRB.start
end

desc 'Display grape routes'
task :routes do
  API.routes.each do |route|
    puts route
  end
end

namespace :updater do
  task :run do
    require 'updater'
    Updater.run
  end
end

begin
  require 'heroku_san'
  config_file = File.join(File.expand_path(File.dirname(__FILE__)), 'config', 'heroku.yml')
  HerokuSan.project = HerokuSan::Project.new(config_file, :deploy => HerokuSan::Deploy::Sinatra)
  load 'heroku_san/tasks.rb'
rescue LoadError
  # The gem shouldn't be installed in a production environment
end

task :default => [:spec]

begin
  require 'rspec/core/rake_task'
  desc "Run specs"
  RSpec::Core::RakeTask.new do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end
rescue LoadError
  # The gem shouldn't be installed in a production environment
end


namespace :db do
  desc 'Drop, create and migrate the databse'
  task :reset do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end

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

      path = File.expand_path('../db/schema.rb', __FILE__)

      File.open(path, "w:utf-8") do |fd|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, fd)
      end
    end
  end
end

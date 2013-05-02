#!/usr/bin/env rake
require File.expand_path('../config/environment', __FILE__)

desc 'Deploy'
task :deploy do
  deploy = lambda { |app|
    sh "heroku maintenance:on -a #{app}"
    sh "git push --force git@heroku.com:#{app}.git HEAD:master"
    sh "heroku run rake db:migrate -a #{app}"
    sh "heroku restart -a #{app}"
    sh "heroku maintenance:off -a #{app}"
  }

  Bundler.with_clean_env do
    deploy['diet-api']
    deploy['diet-workers']
  end
end

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
    Diet::Updater.run
  end
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
    ActiveRecord::Base.establish_connection(Diet.database_config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.create_database(Diet.database_config['database'])
    ActiveRecord::Base.establish_connection(Diet.database_config)
  end

  desc "Drop the database using DATABASE_URL"
  task :drop do
    ActiveRecord::Base.establish_connection(Diet.database_config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.drop_database Diet.database_config['database']
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

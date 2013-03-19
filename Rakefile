#!/usr/bin/env rake
require File.expand_path('../environment', __FILE__)

task :default => [:spec]

require 'rspec/core/rake_task'
desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

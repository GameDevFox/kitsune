require "bundler/gem_tasks"
require "rspec/core/rake_task"

r_spec_task = RSpec::Core::RakeTask.new(:spec)
r_spec_task.pattern = 'lib/**/*.spec.rb'

task :default => :spec

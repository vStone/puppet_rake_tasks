require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'

desc 'Run rubocop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.formatters = %w[fuubar offenses]
  task.fail_on_error = true
end

RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new(:docs)

task default: %i[rubocop spec]

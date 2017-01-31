require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Rake::Task['rubocop'].clear
desc 'Run rubocop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.formatters = %w(fuubar offenses)
  task.fail_on_error = true
end

RSpec::Core::RakeTask.new(:spec)

task default: [:rubocop, :spec]

require 'puppet_rake_tasks/depchecker/resolver'
require 'rake'
require 'rake/tasklib'

module PuppetRakeTasks
  module DepChecker
    # Provide a rake task to check module dependencies
    #
    # @example Run in current directory
    #   require 'puppet_module_task'
    #   PuppetModuleTask::Task::DepChecker.new
    class Task < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)

      # Name of the task. Defaults to `:depcheck`.
      attr_accessor :name

      # Create a new task instance.
      def initialize(*args, &task_block)
        @name = args.shift || :depcheck
        @depchecker = ::PuppetRakeTasks::DepChecker::Resolver.new
        Rake::Task[@name].clear if Rake::Task.task_defined?(@name)
        define(args, &task_block)
      end

      private

      # Core task execution.
      def execution(*_args)
        @depchecker.report unless @depchecker.filtered.empty?
      rescue PuppetRakeTasks::DepChecker::Resolver::Report::DependencyError => ex
        raise ex if Rake.application.options.trace == true || Rake.application.options.backtrace == true
        abort(ex.message)
      end

      # Define the rake task.
      def define(args, &task_block)
        desc 'Check puppet module dependencies'
        yield(@depchecker, *args).slice(0, task_block.arity) if block_given?
        task name, *args, &method(:execution)
      end
    end
  end
end

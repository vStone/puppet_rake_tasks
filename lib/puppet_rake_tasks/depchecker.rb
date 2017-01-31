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

      def initialize(*args, &task_block)
        @name = args.shift || :depcheck
        @depchecker = ::PuppetRakeTasks::DepChecker::Resolver.new
        define(args, &task_block)
      end

      def define(args, &task_block)
        desc 'Check puppet module dependencies'
        yield(@depchecker, *args).slice(0, task_block.arity) if block_given?
        Rake::Task[@name].clear if Rake::Task.task_defined?(@name)
        task @name do
          # TODO: RUN TASK
        end
      end
      private :define
    end
  end
end

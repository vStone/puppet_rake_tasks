require 'puppet'
require 'puppet/module_tool'

require_relative 'helpers'

module PuppetRakeTasks
  module DepChecker
    # Class that can detect all puppet module dependency issues.
    class Resolver
      include Helpers

      def initialize(module_path = '.')
        @modulepath = Helpers.normalize_path(module_path)
      end

      def env
        @env ||= Puppet::ModuleTool.environment_from_options(modulepath: modulepath_s)
      end

      def modules
        @modules ||= Puppet::ModuleTool::InstalledModules.new(env)
      end

      # Clear all cached data (env, modules, incidents)
      def reset_caches
        @env = nil
        @modules = nil
      end

      # Set or default module path.
      def modulepath
        @modulepath ||= ['.']
      end

      # Return modulepath as a string
      def modulepath_s
        @modulepath.flatten.join(File::PATH_SEPARATOR)
      end

      # Set the modulepath
      def modulepath=(path)
        unless path == @modulepath
          # reset the env and loaded modules when changing the modulepath
          reset_caches
        end
        @modulepath = Helpers.normalize_path(path)
      end
    end
  end
end

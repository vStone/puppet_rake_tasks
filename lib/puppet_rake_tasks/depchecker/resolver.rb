require 'puppet'
require 'puppet/module_tool'

require_relative 'helpers'
require_relative 'ignores'
require_relative 'incidents'
require_relative 'filter'

module PuppetRakeTasks
  module DepChecker
    # Class to detect all puppet module dependency issues.
    # It uses puppet module tool internals to detect all issues.
    class Resolver
      include Helpers
      include Ignores
      include Incidents
      include Filter

      def initialize(module_path = '.')
        @modulepath = Helpers.normalize_path(module_path)
      end

      # Returns the puppet module tool environment.
      # @see http://www.rubydoc.info/gems/puppet/Puppet/ModuleTool#environment_from_options-class_method
      def env
        @env ||= Puppet::ModuleTool.environment_from_options(modulepath: modulepath_s)
      end

      # Collect the installed modules using Puppet::ModuleTool.
      # @see http://www.rubydoc.info/gems/puppet/Puppet/ModuleTool/InstalledModules
      def modules
        @modules ||= Puppet::ModuleTool::InstalledModules.new(env)
      end

      # Clear all cached data (env, modules, incidents)
      def reset_caches
        @env = nil
        @modules = nil
        @incidents = nil
      end

      # Returns the configured module paths.
      # @return [Array<String>] configured module paths as an array.
      def modulepath
        @modulepath ||= ['.']
      end

      # Return modulepath as a string
      # @return [String] module paths joined with `File::PATH_SEPARATOR`
      def modulepath_s
        @modulepath.flatten.join(File::PATH_SEPARATOR)
      end

      # Set the modulepath and normalize using {Helpers#normalize_path}
      # When the module path changes, cached values are {#reset_caches cleared}
      # @param [Array<String>,String] path Module paths
      # @return [Array<String>] configured and normalized module paths.
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

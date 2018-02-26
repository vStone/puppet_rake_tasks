require_relative 'helpers'

module PuppetRakeTasks
  module DepChecker
    class Resolver
      # Deal with management of the ignore rules you can set.
      # You can either set all rules in one go using {#ignores=} or add one by one
      # using the {#ignore} method.
      #
      # ## Reference:
      # When referring to the 'simple name' of a puppet module, use the name without `author/` in front.
      # You can not have a module with the same name installed in your tree anyhow.
      #
      # @example Adding a rule for a single module.
      #   # Ignores the stdlib version mismatch on `your_module`.
      #   @depchecker.ignore 'your_module', { name: 'puppetlabs/stdlib', reason: :version_mismatch }
      #
      # @example Adding a rule for a single module with regexp values.
      #   # Ignores all modules from author `custom` that are missing.
      #   @depchecker.ignore 'your_module', { name: %r{^custom/.*}, reason: :missing }
      #
      # @example Adding a rule for all modules using a regexp.
      #   # ignores a missing module for all modules that might declare it as a dependency.
      #   @depchecker.ignore %r{.*}, { name: 'foobar/module', reason: :missing }
      #
      # @example Loading ignores from a (yaml) file
      #   @depchecker.ignores = YAML.load_file('.ignores.yaml')
      #   # .ignores.yaml
      #   # ---
      #   # !ruby/regexp /.*/:
      #   #   - :name: always/missing
      #   #     :reason: :missing
      #   # foobar:
      #   #   - :name: !ruby/regexp /.*/
      #   #     :reason: :version_mismatch
      #
      module Ignores
        extend Helpers

        # Configure all ignore rules at once by setting a single hash.
        # This clears the cached ignore rules for modules.
        # @param ignores [Hash] Hash with ignore rules.
        def ignores=(ignores)
          @ignores = ignores
          @ignores_for_module = {}
        end

        # @param for_module [String,Regexp] module name or regex this rule applies to.
        # @param expr [Hash] ignore expression.
        def ignore(for_module, expr)
          # reset cached ignores matching modules
          (@ignores_for_module ||= {})[for_module] = nil

          # initialize if not exists
          (@ignores ||= {})[for_module] ||= []
          @ignores[for_module] << expr
        end

        # Returns all configured ignore rules.
        # @return [Hash] ignore rules.
        def ignores
          @ignores ||= {}
        end

        # Returns ignore rules that might apply to the modulename and caches the result.
        # @param modulename [String] module name to get ignore rules for in its simple form.
        def ignores_for_module(modulename)
          @ignores_for_module[modulename] ||= collect_ignores_for_module(modulename) if (@ignores_for_module ||= {})[modulename].nil?
          @ignores_for_module[modulename]
        end

        # Loop over ignores for a modulename and check if it matches the incident.
        # @param modulename [String] puppet module name.
        # @param incident [Hash] The module incident to check.
        def ignores_matches_incident(modulename, incident)
          loop_ignores = ignores_for_module(modulename)
          # Look for a match, return true immediately, otherwise, false
          loop_ignores.each do |ign|
            this_ignore = true
            ign.each_key do |k|
              compare = Helpers.compare_values(ign[k], incident[k])
              this_ignore = false unless compare
            end
            return true if this_ignore
          end
          false
        end

        private

        # @param modulename [String] puppet module name. Must be in the 'simple' form.
        # @return [Array] array with all ignores that apply to a certain puppet module.
        def collect_ignores_for_module(modulename)
          tmp_ignores = []
          ignores.each do |k, i|
            tmp_ignores += i if (k.is_a?(String) && k == modulename) || (k.is_a?(Regexp) && modulename =~ k)
          end
          tmp_ignores
        end
      end
    end
  end
end

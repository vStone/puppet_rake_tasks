require 'pp'

module PuppetRakeTasks
  module DepChecker
    class Resolver
      # Prints stuff to `stderr` and optionally raises an error
      module Report
        extend Helpers

        # Make sure we don't throw a too generic error.
        class DependencyError < StandardError
          attr_reader :filtered
          def initialize(message, filtered)
            @filtered = filtered
            super(message)
          end
        end

        attr_writer :fail_on_error
        attr_writer :format
        attr_writer :output

        def output
          @output ||= $stderr
        end

        # Returns the format configured (or the default format)
        # @return [String] string fed into sprintf.
        def format
          @format ||= 'ERROR: module %<module_name>s: %<reason>s dependency %<name>s. '\
            "Wants: '%<version_constraint>s', got: '%<mod_details.installed_version>s'\n"
        end

        # Boolean indicating wether or not we will fail (raise error) when there are incidents.
        # @return [Boolean]
        def fail_on_error
          @fail_on_error ||= false
        end

        # Gets all filtered incidents for all modules and reports them module by module.
        # @raise [DependencyError] if there are any issues detected and `fail_on_error` is enabled (`true`)
        def report
          filtered.each do |module_name, module_incidents|
            format_module_incidents(module_name, module_incidents)
          end
          raise DependencyError.new('Module errors found', filtered) unless filtered.empty? || !fail_on_error
        end

        # Adds extra information to the incident hash for reporting purposes.
        # @param incident [Hash] Incident to enrich.
        # @return [Hash] copy of the incident with extra data and a default_proc assigned.
        def enrich_incident(incident)
          incident = Helpers.swat_hash(incident)
          # For recent enough ruby versions, this default proc will just show missing
          # keys in stead of failing on them (when using sprintf).
          incident.default_proc = proc { |hash, key| hash[key] = "%<#{key}>s" }
          incident
        end

        # Format all incidents for a certain module.
        # @param module_name [String] name of the module the incidents are detected for.
        # @param module_incidents [Array<Hash>] All incidents.
        def format_module_incidents(module_name, module_incidents)
          module_incidents.each do |incident|
            # Add the module_name to the incident
            info_hash = incident.merge(module_name: module_name)
            format_incident(info_hash)
          end
        end

        # Format a single incident.
        # @param info_hash [Hash] hash with all information for the incident.
        def format_incident(info_hash)
          output.puts(Kernel.format(format, enrich_incident(info_hash)))
        end
      end
    end
  end
end

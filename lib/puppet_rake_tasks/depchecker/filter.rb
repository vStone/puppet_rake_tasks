module PuppetRakeTasks
  module DepChecker
    class Resolver
      # Apply ignore rules to incidents and return the filtered results
      module Filter
        # @return [Hash] list with filtered incidents (cached).
        def filtered
          @filtered ||= filter_incidents
        end

        private

        # This method calls ignores_matches_incident for each issue and removes it
        # if the result of the call is true. The ignores_matches_incident will loop
        # all configured ignores (global/wildcards or specific for the module)
        # @param issues [Array] An array with all issues related to the module to check.
        # @param modulename [String] simple module name to filter incidents for.
        # @return [Array] with filtered issues.
        def filter_module_incidents(modulename, issues)
          ## Reject all incidents that match an ignore rule
          issues.reject do |incident|
            ignores_matches_incident(modulename, incident)
          end
        end

        # Loop all incidents and apply the ignore filters for each module.
        # Modules without no incidents (emtpy array) are also removed from the result.
        # @return [Hash] filtered incidents.
        def filter_incidents
          intermediate = incidents.update(incidents) do |modulename, issues|
            filter_module_incidents(modulename, issues)
          end
          intermediate.reject { |_m, i| i.empty? }
        end
      end
    end
  end
end

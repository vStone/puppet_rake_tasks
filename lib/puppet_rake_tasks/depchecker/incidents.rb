module PuppetRakeTasks
  module DepChecker
    class Resolver
      # Collect all incidents
      module Incidents
        # Returns all (cached) detected incidents in modules.
        # @return [Hash] all incidents.
        def incidents
          @incidents ||= initialize_incidents
        end

        # Detect all incidents for the current env.
        # @return [Hash] incidents.
        def initialize_incidents
          tmp_incidents = {}
          modules.by_name.each do |name, mod|
            mod.unmet_dependencies.each do |incident|
              tmp_incidents[name] ||= []
              tmp_incidents[name] << incident
            end
          end
          tmp_incidents
        end
      end
    end
  end
end

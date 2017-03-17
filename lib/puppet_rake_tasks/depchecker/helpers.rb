module PuppetRakeTasks
  module DepChecker
    # General helpers
    module Helpers
      class << self
        def normalize_path(path)
          if path.is_a?(String)
            path.split(File::PATH_SEPARATOR)
          else
            [path].flatten
          end
        end

        def compare_values(ignore_value, incident_value)
          if ignore_value.is_a?(Regexp)
            !ignore_value.match(incident_value.to_s).nil?
          else
            incident_value = incident_value.is_a?(Symbol) ? incident_value.to_s : incident_value
            ignore_value = ignore_value.is_a?(Symbol) ? ignore_value.to_s : ignore_value
            incident_value == ignore_value
          end
        end
      end
    end
  end
end

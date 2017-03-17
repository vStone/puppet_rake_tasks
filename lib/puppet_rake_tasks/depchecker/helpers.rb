module PuppetRakeTasks
  module DepChecker
    # General helpers for various methods.
    module Helpers
      class << self

        # Normalize paths split by `File::PATH_SEPARATOR` by making sure it always
        # returns an array of paths.
        # @param path [String,Array] A string or an array with paths.
        # @return [Array] The normalized paths
        def normalize_path(path)
          if path.is_a?(String)
            path.split(File::PATH_SEPARATOR)
          else
            [path].flatten
          end
        end

        # Compare values by converting symbols to strings or by using
        # regexes to match if the ignore_value is one.
        # @param ignore_value [String,Regex,Symbol] Value to compare
        # @param incident_value [String, Symbol] Value to compare against.
        # @return [Boolean] true or false depending on the equality-ish-ness.
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

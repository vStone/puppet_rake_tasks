module PuppetRakeTasks
  module DepChecker
    class Resolver
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
        end
      end
    end
  end
end

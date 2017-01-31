$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'puppet_rake_tasks'

FIXTURES_ROOT = File.join(File.dirname(__FILE__), "fixtures") unless defined?(FIXTURES_ROOT)

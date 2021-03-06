
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet_rake_tasks/version'

Gem::Specification.new do |spec|
  spec.name          = 'puppet_rake_tasks'
  spec.version       = PuppetRakeTasks::VERSION
  spec.authors       = ['Jan Vansteenkiste']
  spec.email         = ['jan@vstone.eu']

  spec.summary       = 'Contains various rake tasks for your puppet tree.'
  spec.description   = <<-DESCRIPTION
    DepChecker: Creates a rake task that uses puppet module to check dependencies.'
  DESCRIPTION
  spec.homepage      = 'https://github.com/vStone/rake-puppet_module_task'
  spec.license       = 'GPL-3'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_dependency 'puppet', '~> 4.0'
end

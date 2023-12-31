# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aladtec/version'

Gem::Specification.new do |spec|
  spec.name          = 'aladtec'
  spec.version       = Aladtec::VERSION
  spec.authors       = ['Travis Dahlke']
  spec.email         = ['dahlke.travis@gmail.com']
  spec.summary       = 'Client library for the Aladtec API'
  spec.description   = %(Retrieve schedules and events from the Aladtec API.
     Works with EMS Manager, Fire Manager, Zanager. )
  spec.homepage      = 'https://github.com/travisdahlke/aladtec'
  spec.license       = 'MIT'

  spec.required_ruby_version = '> 2.5'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'

  spec.add_dependency 'dry-configurable'
  spec.add_dependency 'dry-initializer'
  spec.add_dependency 'http'
end

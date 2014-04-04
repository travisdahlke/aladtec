# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aladtec_client/version'

Gem::Specification.new do |spec|
  spec.name          = "aladtec_client"
  spec.version       = AladtecClient::VERSION
  spec.authors       = ["Travis Dahlke"]
  spec.email         = ["dahlke.travis@gmail.com"]
  spec.summary       = %q{Client library for the Aladtec API}
  spec.description   = %q{Retrieve schedules and events from the Aladtec API. Works with EMS Manager, Fire Manager, Zanager.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "multi_xml" ,"~> 0.5.5"
end

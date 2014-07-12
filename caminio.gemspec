# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caminio/version'

Gem::Specification.new do |spec|
  spec.name          = "caminio"
  spec.version       = Caminio::VERSION
  spec.authors       = ["quaqua"]
  spec.email         = ["quaqua@tastenwerk.com"]
  spec.summary       = %q{sinatra web framework}
  spec.description   = %q{caminio is a sinatra rest framework}
  spec.homepage      = "https://github.com/caminio/caminio"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.1.0"
  spec.add_dependency "grape"
  spec.add_dependency "ember-rails"
  spec.add_dependency "ember-source", "1.6.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end

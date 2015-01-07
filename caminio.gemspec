# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caminio/version'

Gem::Specification.new do |spec|
  spec.name          = "caminio"
  spec.version       = Caminio::VERSION
  spec.authors       = ["quaqua"]
  spec.email         = ["quaqua@tastenwerk.com"]
  spec.summary       = %q{authentication point API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.0.0"
  spec.add_dependency "grape", "~> 0.10"
  spec.add_dependency "grape-entity", "~> 0.4"
  spec.add_dependency "i18n", "~> 0.7"
  spec.add_dependency "mongoid", "~> 4.0"
  spec.add_dependency "roadie", "~> 3.0"
  spec.add_dependency "roadie-rails", "~> 1.0.4"
  spec.add_dependency "sprockets", "~> 2.12"
  spec.add_dependency "sprockets-helpers", "~> 1.1"
  spec.add_dependency "handlebars_assets", "~> 0.18"
  spec.add_dependency "coffee-script", "~> 2.3"
  spec.add_dependency "paperclip", "~> 4.2.1"

  spec.add_dependency "request_store", "~> 1.1"
  spec.add_dependency "rack-cors", "~> 0.2"
  spec.add_dependency "bcrypt", "~> 3.1"

  spec.add_development_dependency "factory_girl", "~> 4.5"
  spec.add_development_dependency "database_cleaner", "~> 1.3.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "simplecov", "~> 0.9"
end

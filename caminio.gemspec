# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caminio/version'

Gem::Specification.new do |spec|
  spec.name          = "caminio"
  spec.version       = Caminio::VERSION
  spec.authors       = ["quaqua"]
  spec.email         = ["quaqua@tastenwerk.com"]
  spec.summary       = %q{web cms}
  spec.description   = %q{caminio web cms}
  spec.homepage      = "https://github.com/caminio/caminio"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize"
  spec.add_dependency "json"
  spec.add_dependency "rails", "~> 4.1.0"
  spec.add_dependency "mongoid", "~> 4.0.0"
  spec.add_dependency "mongoid_userstamp", "~> 0.4.0"
  spec.add_dependency "mongoid-versioning", "~> 1.0.0"
  spec.add_dependency "mongoid_paranoia", "~> 0.1.2"
  spec.add_dependency "request_store", "~> 1.1.0"
  spec.add_dependency "grape", "0.8.0"
  spec.add_dependency "grape-rabl", "0.2.2"
  spec.add_dependency "bcrypt", "3.1.7"
  spec.add_dependency "rack-oauth2", "1.0.8"
  spec.add_dependency "roadie-rails"
  spec.add_dependency "paperclip", "~> 4.1"
  # spec.add_dependency "doorkeeper"
  spec.add_dependency "mongoid-paperclip", "~> 0.0.9"
  # spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "factory_girl_rails"

end

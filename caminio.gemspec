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

  spec.add_dependency "rails", "~> 4.1.6"
  spec.add_dependency "request_store", "~> 1.1.0"
  spec.add_dependency "grape", "0.8.0"
  spec.add_dependency 'grape-swagger', '0.7.2'
  spec.add_dependency 'active_model_serializers', '~>0.9.1'
  spec.add_dependency 'grape-active_model_serializers', '~> 1.3.1'
  spec.add_dependency 'handlebars_assets'
  spec.add_dependency "bcrypt", "3.1.7"
  spec.add_dependency "roadie-rails"
  spec.add_dependency "paperclip", "~> 4.1"

  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'database_cleaner', '~> 1.3.0'
  spec.add_development_dependency 'rack-test', '~> 0.6.2'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "factory_girl_rails"

end

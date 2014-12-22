# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caminio/version'

Gem::Specification.new do |spec|
  spec.name          = "caminio"
  spec.version       = Caminio::VERSION
  spec.authors       = ["thorsten zerha"]
  spec.email         = ["thorsten.zerha@tastenwerk.com"]
  spec.summary       = %q{core API for user authentication and license management}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sqlite3', '~> 1.3.10'
  spec.add_dependency 'activerecord', '~> 4.1.8'
  spec.add_dependency 'grape', '~> 0.9.0'
  spec.add_dependency 'grape-swagger', '0.7.2'
  spec.add_dependency 'request_store', '~> 1.1.0'
  spec.add_dependency 'hashie', '~> 3.3.2'
  spec.add_dependency 'puma', '~> 2.10.2'
  spec.add_dependency 'bcrypt', '~> 3.1.9'
  spec.add_dependency 'rack-cors', '~> 0.2.9'
  spec.add_dependency 'active_model_serializers', '~>0.9.0'
  spec.add_dependency 'grape-active_model_serializers', '~> 1.3.1'
  spec.add_dependency 'i18n', '~> 0.6.11'
  spec.add_dependency 'actionmailer', '~> 4.1.8'
  
  spec.add_development_dependency 'guard-puma', '~> 0.3.1'
  spec.add_development_dependency 'rack-test', '~> 0.6.2'
  spec.add_development_dependency 'factory_girl', '~> 4.5.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'database_cleaner', '~> 1.3.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

end

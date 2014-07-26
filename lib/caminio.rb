# 3rd
require "grape"
require "roadie-rails"
# require "doorkeeper"

require "caminio/version"
require "caminio/schemas/web_object"

# setup caminio namespace for use in config/application.rb
require "caminio/config_namespace"

require "caminio/has_access_rules"

# Rails engine
require "caminio/engine"

# 3rd
require "grape"
require "roadie-rails"
require "paperclip"
require "caminio/paperclip_grape_ext"
# require "doorkeeper"
#

require "caminio/version"
require "caminio/schemas/row"

# setup caminio namespace for use in config/application.rb
require "caminio/config_namespace"

require "caminio/has_access_rules"

# Rails engine
require "caminio/engine"

# Access rights
require "caminio/access"
require "caminio/model_registry"

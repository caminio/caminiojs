# 3rd
require "grape"
# require "grape/rabl"
require 'grape-active_model_serializers'
require "roadie-rails"
require "paperclip"
# require "mongoid_paperclip"
# require "caminio/paperclip_grape_ext"
# require "doorkeeper"
#

require "caminio/version"
require "caminio/schemas/row"

# setup caminio namespace for use in config/application.rb
require "caminio/config_namespace"

require 'caminio/controller_commons'

# require "caminio/access_rules"
require "caminio/user_stamps"


# Rails engine
require "caminio/engine"

